# 1. Mettre à jour les paquets
sudo apt update && sudo apt install -y ca-certificates curl apt-transport-https lsb-release gnupg

# 2. Ajouter la clé Microsoft
curl -sL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# 3. Ajouter le dépôt Azure CLI
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# 4. Mettre à jour et installer Azure CLI
sudo apt update
sudo apt install -y azure-cli

# 5. Vérifier l’installation
az version

az login                         
az account show                 
az account list --output table  


sudo chown raslen:raslen ~/.kube/config
chmod 600 ~/.kube/config
az aks get-credentials --resource-group rg-raslen-cert --name raslen-cert-aks


az aks show --resource-group rg-raslen-cert --name raslen-cert-aks --query nodeResourceGroup -o tsv


NODE_RG_NAME="MC_rg-raslen-cert_raslen-cert-aks_eastus" 
az network nsg list --resource-group $NODE_RG_NAME --query "[].name" -o tsv


NODE_RG_NAME="MC_rg-raslen-cert_raslen-cert-aks_eastus" 
NSG_NAME="aks-agentpool-23211147-nsg" 

echo "Ajout des règles au NSG : $NSG_NAME dans le groupe $NODE_RG_NAME"

az network nsg rule create \
  --resource-group $NODE_RG_NAME \
  --nsg-name $NSG_NAME \
  --name AllowHTTPInbound \
  --priority 1000 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes Internet \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 \
  --description "Allow inbound HTTP traffic to AKS Ingress"
echo "Règle AllowHTTPInbound créée."

# Règle pour HTTPS (port 443)
az network nsg rule create \
  --resource-group $NODE_RG_NAME \
  --nsg-name $NSG_NAME \
  --name AllowHTTPSInbound \
  --priority 1001 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes Internet \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 443 \
  --description "Allow inbound HTTPS traffic to AKS Ingress"
echo "Règle AllowHTTPSInbound créée."