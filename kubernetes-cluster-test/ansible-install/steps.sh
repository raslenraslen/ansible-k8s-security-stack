#!/bin/bash

# Ajouter le PPA d'Ansible
sudo apt-add-repository ppa:ansible/ansible -y

# Mettre à jour les informations des paquets
sudo apt update

# Installer Ansible
sudo apt install ansible -y
echo "raslen ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo


# Vérifier l'installation
ansible --version