# Lab 8 - Working with AWS Load Balancer Controller

For this lab, you will need to execute the script `~/environment/eks/labs/08-ingress/configure-ingress.sh` to install the AWS Load Balancer Controller in the Cluster. You can check more information regarding the AWS Load Balancer Controller [here](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/) and [here](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html).

```bash
~/environment/eks/labs/08-ingress/configure-ingress.sh
```

## Verify that the AWS Load Balancer Controller is Running

 After installing the the Ingress Controller, check that the controller pod is running:

```bash
$ kubectl get deployment -n kube-system aws-load-balancer-controller
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   1/1     1            1           51d

$ kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
NAME                                            READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-76cb6647f4-xnfz8   1/1     Running   0          4d1h
```

## Deploy a Sample Application

We will now deploy a sample application, `2048game` to verify that the AWS LoadBalancer Controller creates an Application Load Balancer as a result of the Ingress object:

```bash
$ kubectl apply -f 2048-game.yaml
namespace/game-2048 created
deployment.apps/deployment-2048 created
service/service-2048 created
ingress.extensions/ingress-2048 created
```

## Verify Ingress Created

After a few minutes, verify that the Ingress resource was created with the following command:

```bash
$ kubectl get ingress/ingress-2048 -n game-2048
NAME           CLASS    HOSTS   ADDRESS                                                                      PORTS   AGE
ingress-2048   <none>   *       k8s-game2048-ingress2-18f0d834a4-1377718652.eu-central-1.elb.amazonaws.com   80      1d
```

Try accessing the game using the `ADDRESS` returned from the previous command. Ensure the protocol used is `http` and not `https`.
