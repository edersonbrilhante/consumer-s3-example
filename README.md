# consume-s3-example

## Deploing Infrastructure

Here you will find the steps to deploy the infrastructure.

### Deploy EKS and S3

```bash
cd deployment/terraform/eks/
terraform apply -var-file=variables.tfvars
export KUBECONFIG=$(pwd)/.kubeconfig_my-cluster
cd ../../../
```

### Associate an oidc provider for the cluster

```bash
eksctl utils associate-iam-oidc-provider --region=us-west-1 --cluster=consume-s3-example --approve
```

### Deploy iam role for EKS's service account

```bash
ISSUER_URL=$(aws eks describe-cluster --name consume-s3-example --region=us-west-1 --query cluster.identity.oidc.issuer --output text)
export TF_VAR_oidc_provider=$(echo $ISSUER_URL | cut -f 3- -d'/')
export TF_VAR_eks_sa="consume-s3-example"
cd deployment/terraform/assume-role
terraform apply -var-file=variables.tfvars
ROLE_STS_ARN=$(terraform output eks_sa_role)
```

## Deploing Application

### Deploy helm chart

```bash
helm upgrade --install consume-s3-example ./deployment/helm/consume-s3-example --set s3.role_sts_arn=$ROLE_STS_ARN
```

## Ideas how to implement in CI/CD

- 1 Runner with IAM role to change AWS resources
- 1 Runner with access to internet to build docker
- 1 Runner with access to eks cluster
- Jobs
- Job for infra:
  - cd deployment/terraform:
    - ```terraform plan -var-file=<file>```
    - ```terraform apply -var-file=<file>```
- Job for docker:
  - ```docker build -t <tag> -f deployment/docker/Dockerfile .```
  - ```docker push <tag>```
- Job for helm:
  - ```helm upgrade --install consume-s3-example deployment/helm/consume-s3-example```
