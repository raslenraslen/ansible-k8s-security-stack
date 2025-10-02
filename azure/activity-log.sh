# STEP 0 — Exporter les variables (si pas déjà définies)
export RG_NAME="rg-raslen-cert"
export AKS_NAME="raslen-cert-aks"
export LOCATION="eastus"
export WS_NAME="raslen-logs-ws"

# Vérifie que c'est bien pris :
echo "RG_NAME=$RG_NAME"
echo "AKS_NAME=$AKS_NAME"
echo "LOCATION=$LOCATION"
echo "WS_NAME=$WS_NAME"


# STEP 1 — Vérifier que tu es connecté à Azure
az account show --output table


# STEP 2 — Création du Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group $RG_NAME \
  --location $LOCATION \
  --workspace-name $WS_NAME


# STEP 3 — Récupérer l'ID complet du Workspace et le stocker dans une variable
WS_ID=$(az monitor log-analytics workspace show \
    --resource-group $RG_NAME \
    --workspace-name $WS_NAME \
    --query id -o tsv)

# Vérifier l'ID récupéré
echo "ID du Workspace récupéré : $WS_ID"


# STEP 4 — Activation de l'addon monitoring (Container Insights) sur AKS
az aks enable-addons \
    --addons monitoring \
    --resource-group $RG_NAME \
    --name $AKS_NAME \
    --workspace-resource-id $WS_ID



# 4.A — Activity Log (Audit Cloud)

az monitor activity-log list \
  --resource-group $RG_NAME \
  --max-events 10 \
  --query '[].{Time:eventTimestamp, Operation:operationName, Caller:caller, Status:status}' \
  -o table
