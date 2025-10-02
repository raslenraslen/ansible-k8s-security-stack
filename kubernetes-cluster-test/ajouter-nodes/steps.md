#  Comment ajouter un nouveau Worker (sans changer le code du playbook) :

# Méthode 1 : Modifier inventory.ini et utiliser le ciblage de hosts


**Ajoute ton nouveau worker dans inventory.ini :**

````
[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args="-o ControlPath=/tmp/ssh_mux_%h_%p_%r"

[controllers]
controller1 ansible_host=192.168.216.141 ansible_user=raslen

[workers]
workerker1 ansible_host=192.168.216.139 ansible_user=raslenworker
workerker2 ansible_host=NOUVELLE_IP_DU_WORKER2 ansible_user=raslenworker # <-- Ajoute cette ligne
````

**Exécute ton playbook site.yml en ciblant uniquement le nouveau worker :**

````
ansible-playbook -i inventory.ini site.yml  -l workerker2
````


**-l workerker2 :**  Cela dit à Ansible de n'exécuter aucune tâche de ce playbook sur d'autres hôtes que workerker2, même si le playbook cible hosts: all.


# Que se passera-t-il sur workerker2 ?
Le rôle kubernetes_cluster sera exécuté sur workerker2.  

tasks/main.yml du rôle s'exécutera.  

prerequisites.yml s'exécutera sur workerker2 (car il est ciblé).  

master.yml sera sauté sur workerker2 car workerker2 n'est pas dans le groupe controllers (when: inventory_hostname in groups['controllers'] sera False).  

worker.yml s'exécutera sur workerker2 car il est dans le groupe workers (when: inventory_hostname in groups['workers'] sera True), ce qui le fera joindre le cluster.  


# Si tu ajoutes workerker2, workerker3, workerker4 à ton inventory.ini, tu peux les spécifier avec des virgules :

````
ansible-playbook -i inventory.ini site.yml  -l workerker2,workerker3,workerker4
````


# Option 2 : Créer un nouveau groupe temporaire dans l'inventaire (si tu as beaucoup de nouveaux hôtes ou que tu veux les gérer ensemble)

Modifie ton inventory.ini et ajoute un nouveau groupe pour tes "nouveaux workers".


````
[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args="-o ControlPath=/tmp/ssh_mux_%h_%p_%r"

[controllers]
controller1 ansible_host=192.168.216.141 ansible_user=raslen

[workers]
workerker1 ansible_host=192.168.216.139 ansible_user=raslenworker

[new_workers]
workerker2 ansible_host=192.168.216.143 ansible_user=raslenworker
workerker3 ansible_host=192.168.216.144 ansible_user=raslenworker
workerker4 ansible_host=192.168.216.145 ansible_user=raslenworker
````

Exécute ton playbook en ciblant ce nouveau groupe :

````
ansible-playbook -i inventory.ini site.yml  -l new_workers
````