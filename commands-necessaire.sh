sudo chown -R raslen:raslen ~/.kube
terraform apply --auto-approve
az aks get-credentials --resource-group rg-raslen-cert --name raslen-cert-aks
kubectl get nodes
kubectl config use-context kubernetes-admin@kubernetes
kubectl get nodes
kubectl config use-context raslen-cert-aks
kubectl get nodes