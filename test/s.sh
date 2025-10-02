# 1. Trouver tous les processus Ansible et les tuer
sudo pkill -f ansible-playbook
sudo pkill -f python3

# 2. Nettoyer tous les locks APT
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/lib/dpkg/lock
sudo rm -f /var/cache/apt/archives/lock

# 3. Vérifier qu'aucun processus ne bloque
sudo lsof /var/lib/apt/lists/lock || echo "Aucun lock actif"

# 4. Tester l'installation manuelle de Helm pour vérifier
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 5. Vérifier que Helm est installé
helm version --short