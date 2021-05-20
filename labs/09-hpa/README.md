# Lab 9 - Working Horizontal Pod Autoscaler

For this lab, we will need to install [Kubernetes Metrics Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html) onto the Cluster. More information can be found in the documentation [here](https://docs.aws.amazon.com/eks/latest/userguide/horizontal-pod-autoscaler.html).

## Deploy Metrics Server

1. Deploy the Metrics Server with the following command:

  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```

  Verify that the metrics-server deployment is running the desired number of pods with the following command:

  ```bash
  $ kubectl get deployment metrics-server -n kube-system
  NAME             READY   UP-TO-DATE   AVAILABLE   AGE
  metrics-server   1/1     1            1           6m
  ```

2. Once Metrics Server is installed, let's update the deployment from the previous lab by adding the following lines:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    namespace: game-2048
    name: deployment-2048
  spec:
    selector:
      matchLabels:
        app.kubernetes.io/name: app-2048
    replicas: 1
    template:
      metadata:
        labels:
          app.kubernetes.io/name: app-2048
          app: "2048"
      spec:
        containers:
        - image: alexwhen/docker-2048
          imagePullPolicy: Always
          name: app-2048
          ports:
          - containerPort: 80
  *        resources:
  *          limits:
  *            cpu: 300m
  *          requests:
  *            cpu: 200m

  ```

3. Apply the new version:

```bash
$ kubectl apply -f 2048-deployment-hpa.yaml
deployment.apps/deployment-2048 configured
```

4. Create a Horizontal Pod Autoscaler resource for the 2048 deployment.

```bash
$ kubectl autoscale deployment deployment-2048 -n game-2048 --cpu-percent=50 --min=1 --max=10
horizontalpodautoscaler.autoscaling/deployment-2048 autoscaled
```

5. Describe the autoscaler with the following command to view its details.

```bash
kubectl describe hpa/deployment-2048 -n game-2048
```

Output:

```
Name:                                                  deployment-2048
Namespace:                                             game-2048
Labels:                                                <none>
Annotations:                                           <none>
CreationTimestamp:                                     Sat, 24 Apr 2021 12:07:53 +0200
Reference:                                             Deployment/deployment-2048
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  1s% (1m) / 50%
Min replicas:                                          1
Max replicas:                                          10
Deployment pods:                                       1 current / 1 desired
Conditions:
  Type            Status  Reason               Message
  ----            ------  ------               -------
  AbleToScale     True    ScaleDownStabilized  recent recommendations were higher than current one, applying the highest recent recommendation
  ScalingActive   True    ValidMetricFound     the HPA was able to successfully calculate a replica count from cpu resource utilization (percentage of request)
  ScalingLimited  False   DesiredWithinRange   the desired count is within the acceptable range
Events:           <none>
```

As you can see, the current CPU load is only one percent, but the pod count is already at its lowest boundary (one), so it cannot scale in.

6. Lets create some load on our game. The following command uses the Apache Bench program to send hundreds of thousands of requests. This should significantly increase the load and cause the autoscaler to scale out the deployment.

```bash
kubectl run apache-bench -it --rm --image=httpd -- ab -n 500000 -c 1000 http://service-2048.game-2048.svc.cluster.local/
```

7. Open a new tab on your Cloud9 Environment and check the pod scaling with the command:

```bash
$ kubectl get horizontalpodautoscaler.autoscaling/deployment-2048 -n game-2048 -w
NAME              REFERENCE                    TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
deployment-2048   Deployment/deployment-2048   0%/50%    1         10        1          3m7s
deployment-2048   Deployment/deployment-2048   107%/50%   1         10        1          3m23s
deployment-2048   Deployment/deployment-2048   107%/50%   1         10        3          3m38s
```
