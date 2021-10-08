# Create playground cluster

This project uses `Google Kubernetes Engine` (**GKE**) to provide playground resources. The `Terraform` code is created to deploy here.

## Prerequisites

- Terraform 0.13 or higher
- Azure Provider 2.57 or higher
- Azure Cloud Platform (**Azure**) account with enough permissions to spin-up a `AKS cluster`

## Create playground cluster steps

### Prepare Gcloud CLI

Ensure that you are logged in from the `az CLI` and set your *default project*.
```
az login
```

### Apply Terraform

First run `terraform plan` to ensure everything is set to `apply`. Advice is to create a `terrraform.tfvars` file to include your specific variables, like the actual `project` and `cluster_name`.

```
terraform plan --var-file=terraform.tfvars
terraform apply --var-file=terraform.tfvars
```

### Import GKE cluster into your local kubectl

Run the following command to import the newly created clusters. Please use your own specified `subscription_id`, `tenant_id` and `cluster_name`.

```
az aks get-credentials --resource-group playground-resources --name playground
```

### Validate kubectl and cluster state

Just some simple check to validate everything is running as expected !

```
kubectl get nodes
kubectl get pods --field-selector status.phase!=Running -A
```

You are now ready to deploy some awesome applications to demostrate !

# Testing the oom_killer px script

Open a shell of a running Pod to trigger the OOM Killer. For this we will use the Ubuntu image.
As you may see we will limit the memory to `123Mi`.

```
kubectl run --restart=Never --rm -it --image=ubuntu --limits='memory=123Mi' -- sh
```

To trigger memory usage we are going to use a tool called `stress` . 

```
apt update
apt install -y stress
```
We are going to run `stress` with a memory load of `100Mi` . Everything should work well.

```
stress --vm 1 --vm-bytes 100M &
```

Now start a second `stress` thread to trigger the `OOM Killer`. Now use Pixie to see the PID that was killed.

```
stress --vm 1 --vm-bytes 50M
```
