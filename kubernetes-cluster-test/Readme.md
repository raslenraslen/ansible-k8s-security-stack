# Kubernetes Cluster Deployment with Ansible Roles

![alt text](Screenshots/ansible.jpg)

Ce dépôt contient un playbook Ansible pour déployer un cluster Kubernetes (v1.28) avec un nœud master et des nœuds workers sur des machines Ubuntu. Le playbook est structuré en rôles pour une meilleure organisation et maintenabilité.

## Prérequis

Avant de lancer le playbook, assurez-vous d'avoir les éléments suivants :

1.  **Machines Virtuelles/Serveurs :**
    *   Au moins deux machines Ubuntu (recommandé : 22.04 LTS ou plus récent).
    *   Un minimum de 2 CPU et 4GB de RAM par nœud Kubernetes (surtout pour le master).
    *   Swap désactivé sur toutes les machines (le playbook le fera automatiquement, mais c'est une bonne pratique de s'en souvenir).
    *   Connexion SSH configurée et fonctionnelle entre votre machine de contrôle Ansible et tous les nœuds cibles.
    *   Un utilisateur `sudo` configuré sur chaque machine cible.

2.  **Machine de Contrôle Ansible :**
    *   Ansible installé (version 2.10 ou plus récente recommandée).
    *   Clé SSH privée (`~/.ssh/id_rsa`) sur votre machine de contrôle, accessible par Ansible pour se connecter aux nœuds cibles.
    *   Le répertoire `Remote_Files` à la racine de ce projet.




## Étapes de Déploiement

Suivez ces étapes pour déployer votre cluster Kubernetes :

### 1. Cloner le Dépôt

```bash
git clone https://github.com/raslenraslen/kubernetes-ansible-roles
cd votre_repo

```

# 2. Configurer l'Inventaire

Ouvrez le fichier inventory.ini et mettez à jour les adresses IP (ansible_host) et les noms d'utilisateur (ansible_user) pour vos nœuds controller1 et workerker1 (et d'autres workers si vous en avez).

````
# inventory.ini
[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args="-o ControlPath=/tmp/ssh_mux_%h_%p_%r"

[controllers]
controller1 ansible_host=VOTRE_IP_MASTER ansible_user=VOTRE_USER_MASTER

[workers]
workerker1 ansible_host=VOTRE_IP_WORKER1 ansible_user=VOTRE_USER_WORKER
# Ajoutez d'autres workers ici si nécessaire
# workerker2 ansible_host=VOTRE_IP_WORKER2 ansible_user=VOTRE_USER_WORKER
````

# 3. Exécuter le Playbook

```
cd cluster-k8s
ansible-playbook -i inventory.ini site.yml 
```

Le playbook va :

-Installer les prérequis sur toutes les machines.  
-Initialiser le nœud master (controller1).  
-Récupérer la chaîne de jointure du cluster.  
-Joindre les nœuds workers au cluster.  


![alt text](Screenshots/nodes.PNG)