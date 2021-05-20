# Lab 4 - Labeling our Pods

For this lab, you'll need to be in the `~/environment/eks/labs/04-labels` directory in Cloud9:

```bash
cd ~/environment/eks/labs/04-labels
```

## Labels in the Object Definition

Take a look at `label-pod.yaml` in your Cloud9 environment.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: echo-server
  labels:
    env: training
    type: single_pod
spec:
  containers:
  - name: echo
    image: k8s.gcr.io/echoserver:1.10
```

- Which image will this pod be using? Where is the image going to come from?
- What other useful labels can you think of?

## Creating a Pod with Labels

```bash
# Apply the spec to our cluster
$ kubectl apply -f label-pod.yaml

# List the pods
$ kubectl get pods --show-labels
```

- Can you describe this new pod?
- Can you see the labels when you describe the pod?
- What command will you use in `kubectl` to query for pods that have the `env: training` label?
