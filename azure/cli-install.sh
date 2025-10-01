sudo apt update && sudo apt install -y ca-certificates curl apt-transport-https lsb-release gnupg

# 2. Ajouter la clé Microsoft
curl -sL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# 3. Ajouter le dépôt Azure CLI
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# 4. Mettre à jour et installer Azure CLI
sudo apt update
sudo apt install -y azure-cli