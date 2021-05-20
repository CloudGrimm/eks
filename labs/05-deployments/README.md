# Lab 5 - Deployments

For this lab, you'll need to be in the `~/environment/eks/labs/05-deployments` directory in Cloud9:

```bash
cd ~/environment/eks/labs/05-deployments
```

## Define a Deployment

Take a look at the deployment definition `deployment.yaml` in the Cloud9 editor.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-server
  template:
    metadata:
      labels:
        app: web-server
    spec:
      containers:
      - name: server
        image: nginx:1.7.9
```

- How many pods will this deployment manage?
- What will the deployment be called?
- What names will be given to the pods in our deployment?

## Create our Deployment

Apply the deployment configuration to your cluster.

```bash
kubectl apply -f deployment.yaml
```

## Checking the Results

You can query the deployment in the cluster:

```bash
kubectl get deployments
kubectl get pods
kubectl get pods -l app=web-server
```

## Scaling the Deployment

Scale the deployment to 5 replicas:

```bash
kubectl scale deployment web-server-deployment --replicas=5
```

## Port Forward to one of the Pods

```bash
$ kubectl get pods

# Pick one of the pods to perform a request
$ kubectl port-forward web-server-deployment-xxxx-xxxxx 8080:80 &

$ curl localhost:8080

$ fg
# Ctrl + C to close the port forward
```

## Scale the Deployment by Editing

You can scale the deployment by editing the replicas:

```bash
$ kubectl edit deployment web-server-deployment

# set the replicas to 3
```

## Check the Results

```bash
kubectl get pods

kubectl get pods -l app=web-server

kubectl get deployments
```

## Deploy a new Image

Update the deployment image to use apache instead:

```bash
$ kubectl set image deployment web-server-deployment server=httpd

# OR
$ kubectl edit deployment web-server-deployment
# change spec.template.spec.containers.image to httpd
```

## Checking the Results

Check the status of our update:

```bash
$ kubectl rollout status deployment web-server-deployment
# OR
$ kubectl get pods
# OR
$ kubectl get pod -l app=web-server -l app
```

## Check what is running in one of the pods

Can we see our change?

```bash
$ kubectl get pods

# Pick one of the pods to perform a request
$ kubectl port-forward web-server-deployment-xxxx-xxxxx 8080:80 &

$ curl localhost:8080

$ fg
# Ctrl + C to close the port forward
```

The pods have now been deployed with the Apache server.
