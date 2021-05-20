#!/bin/sh

CLUSTER=eks
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
ACCOUNT=$(aws sts get-caller-identity --query Account --output text)

echo 'Creating an IAM OIDC provider and associate it with the cluster.'
eksctl utils associate-iam-oidc-provider --region $REGION --cluster $CLUSTER --approve

echo 'Creating an IAM policy called AWSLoadBalancerControllerIAMPolicy for the ALB Ingress Controller pod'
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.3/docs/install/iam_policy.json \
    | jq '.Policy.Arn' | sed 's/"//g'

echo 'Creating a Kubernetes service account named aws-load-balancer-controller in the kube-system namespace'
eksctl create iamserviceaccount \
  --cluster=$CLUSTER \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::"$ACCOUNT":policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

echo 'Deploying CertManager'
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.1.1/cert-manager.yaml

echo 'Waiting 20 seconds for cert-manager to start up...'
sleep 20

echo 'Adding Parameters to the AWS Load Balancer Controller file'
sed 's/your-cluster-name/'$CLUSTER'/g' alb-ingress-controller.yaml.bkp > alb-ingress-controller.yaml

echo 'Deploying the AWS Load Balancer Controller'
kubectl apply -f alb-ingress-controller.yaml

echo 'Waiting 15 seconds for AWS Load Balancer Controller...'
sleep 15

kubectl get deployment -n kube-system aws-load-balancer-controller