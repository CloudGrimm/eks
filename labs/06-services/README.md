# Lab 6 - Services

For this lab, you'll need to be in the `~/environment/eks/labs/06-services` directory in Cloud9:

```bash
cd ~/environment/eks/labs/06-services
```

## Define a Service

Take a look at `service.yaml` in the Cloud9 editor

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: web-server
```

- What will this service's name be?
- Which pods will this service route requests to?

## Create a Service

Apply the config to the Kubernetes cluster

```bash
kubectl apply -f service.yaml
```

## Check our Service

```bash
kubectl get services
kubectl describe service web-app
```

## Change the Service Type

```bash
$ kubectl edit svc web-app

# Change spec.type from 'ClusterIP' to 'LoadBalancer'
```

## Check the Results

```bash
kubectl get svc -o wide

kubectl get svc web-app
```

- Can you locate the load balancer in your AWS account?
- Can you access this service from your browser?
