# AWS Engineering Learning Series - EKS

## Labs

- [Lab 1 - Building a Docker Image](./labs/01-docker)
- [Lab 2 - Introduction to Pods](./labs/02-pods)
- [Lab 3 - Playing around with our Pod](./labs/03-more-pods)
- [Lab 4 - Labeling our Pods](./labs/04-labels)
- [Lab 5 - Deployments](./labs/05-deployments)
- [Lab 6 - Services](./labs/06-services)
- [Lab 7 - Namespaces](./labs/07-namespaces)
- [Lab 8 - Ingress](./labs/08-ingress)
- [Lab 9 - HPA](./labs/09-hpa)

## Launching your Lab Environment

Follow the steps below to get setup with a Cloud9 environment and create your EKS Cluster.

## 1. Launch a Cloud9 Environment

This will be where you'll be performing the labs throughout the sessions.

Click the button to begin creating a CloudFormation stack for the region you are assigned.

Preferably right click and open it in a new tab.

| Region          | CloudFormation     |
| --------------- |:------------------:|
| eu-central-1 (Frankfurt)       | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/review?stackName=cloud9&templateURL=https://eks2021.s3.eu-central-1.amazonaws.com/cloud9-template.yml) |

Tick the `I acknowledge that AWS CloudFormation might create IAM resources.` checkbox then click on the `Create stack` button

If you get stuck, the CloudFormation template is available [here](https://eks2020.s3.eu-central-1.amazonaws.com/cloud9-template.yaml) and also in this [repo](./cloudformation/cloud9-template.yaml).

## 2. Attach the IAM Role to the Cloud9 instance

The IAM role will grant your Cloud9 environment access to perform the actions needed for the sessions.

This can be done in the EC2 console by navigating to your EC2 instances, or clicking the link below (Preferably right click and open it in a new tab):

| Region          | EC2     |
| --------------- |:------------------:|
| eu-central-1 (Frankfurt)       | [Console link](https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Instances:tag:Name=cloud9;sort=instanceState) |

- Select the Cloud9 instance
- Click `Actions` > `Security` > `Modify IAM Role`
- Filter the roles, searching for `cloud9`
- Click `Save` once the role is selected

## 3. Access your Cloud9 environment

This can be done in the Cloud9 console, navigate to Cloud9 or click the link below (Preferably right click and open it in a new tab):


| Region          | EC2     |
| --------------- |:------------------:|
| eu-central-1 (Frankfurt)       | [Console link](https://eu-central-1.console.aws.amazon.com/cloud9/home?region=eu-central-1) |

- Click `Open IDE`

## 4. Setup the Cloud9 environment

The environment will be our workstation for the sessions, there are a few steps needed to get it setup

- From within the Cloud9 environment perform the steps below:
  - Click on the `AWS Cloud9 icon` (top left) > `Preferences`
  - Click on `AWS Settings` > `Credentials`
  - Turn off `AWS managed temporary credentials`

- Change to a dark theme if you prefer:

  - `View` > `Themes` > `UI Themes` > `Classic Dark`

### Run the below commands in the Cloud9 terminal

#### Clone the repository

```bash
git clone https://github.com/aws-els-cpt/eks.git
```

#### Run the bootstrap script

The script installs and configures the necessary pre-requisites

```bash
eks/scripts/bootstrap.sh
```

Confirm the IAM role is as expected

### Launching the EKS Cluster

Launch your cluster from the Cloud9 environment by running the following `eksctl` command:

```bash
eksctl create cluster --version 1.19 --node-type t3.medium --managed --name eks
```

### Ensure that you have nodes attached

If you scaled down your cluster on Day 2 you can scale up using `eksctl` as follows:

```bash
eksctl get clusters
eksctl get nodegroup --cluster eks
eksctl scale nodegroup --cluster=eks --nodes=2 ng-xxxxxxx
```

---

### Submission

Navigate to <https://submissions.vls-kubernetes.support.aws.dev/> and click the `Submit Challenge` button.

1. Please Make sure that the image which you build can be accessed publicly (DockerHub public repo under your account)
2. If you successfully built the application, add the LoadBalancer URL in a file called url.txt , with the http url  **ONLY**
3. Fill out the assessment in [assessment/](https://github.com/aws-els-cpt/eks/tree/master/project/assessment) together with all the yaml files used to solve the problem, zip it and upload it to: <https://submissions.vls-kubernetes.support.aws.dev#uploadChallange>.
4. Make sure to zip all the files in the directory e.g.: `zip -r 01JohnSnow.zip *`

Note:

- The zip file must be named as: `Name` + `Surname`.zip, e.g.: `01JohnSnow.zip`
- **ONLY .zip** files are allowed

---

## Scaling Down your Worker Nodes

Your voucher should cover the costs for the full period of the learning series but if, between sessions, you want to
prevent extra costs you can scale down your clusters using `eksctl` as follows:

```bash
eksctl get clusters
eksctl get nodegroup --cluster eks
eksctl scale nodegroup --cluster=eks --nodes=0 --nodes-min=0 --name ng-xxxxxxx
```

---

## Clean-up (Only do this after the end of all three sessions)

After the end of all three sessions, follow the steps below to delete the EKS cluster and Cloud9 environment

## Delete all Services

Delete all the services of type `LoadBalancer` which have provisioned ELBs in your account:

```bash
# List all services with type LoadBalancer
$ kubectl get svc --all-namespaces -o json \
    | jq -r '.items[] | select(.spec.type == "LoadBalancer") | .metadata.name'

# For each of the outputted services do
$ kubectl delete svc <service name>
service "<service name>" deleted
```

Then you can delete the node group, cluster and CloudFormation stack.

## Delete the EKS cluster

This can be done in the Cloud9 console, navigate to Cloud9, or click the link below:

| Region          | EC2     |
| --------------- |:------------------:|
| eu-central-1 (Frankfurt)       | [Console link](https://eu-central-1.console.aws.amazon.com/cloud9/home?region=eu-central-1) |

- Delete the EKS cluster from the Cloud9 terminal with the below command:

```bash
eksctl delete cluster eks
```

## Delete the Cloud9 CloudFormation stack

This can be done in the CloudFormation console, navigate to CloudFormation, or click the link below:

| Region          | EC2     |
| --------------- |:------------------:|
| eu-central-1 (Frankfurt)       | [Console link](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1) |

There may be a number of stacks, select the stack named "cloud9", and click the "Delete" button
