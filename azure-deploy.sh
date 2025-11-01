#!/bin/bash
# Azure Deployment Script - Cravex v5
# Bu script Matrix Synapse'i Azure Container Instances'a deploy eder

set -e

echo "🚀 Cravex v5 - Azure Deployment"
echo "================================"

# Değişkenler
RESOURCE_GROUP="cravex-rg"
LOCATION="westeurope"
CONTAINER_NAME="matrix-synapse"
DNS_NAME="cravex-matrix"
IMAGE="matrixdotorg/synapse:latest"

# PostgreSQL (Supabase)
POSTGRES_HOST="db.tsmewoznjeixsojqqlud.supabase.co"
POSTGRES_PORT="5432"
POSTGRES_DB="postgres"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="1A6qjJG41TMjee6z"

# Synapse
SYNAPSE_SERVER_NAME="${DNS_NAME}.${LOCATION}.azurecontainer.io"

echo ""
echo "📋 Deployment Detayları:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Location: $LOCATION"
echo "  DNS: $SYNAPSE_SERVER_NAME"
echo ""

# 1. Resource Group Oluştur
echo "1️⃣ Resource Group oluşturuluyor..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# 2. Synapse Container Deploy
echo ""
echo "2️⃣ Matrix Synapse container deploy ediliyor..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image $IMAGE \
  --dns-name-label $DNS_NAME \
  --ports 8008 8448 \
  --cpu 2 \
  --memory 4 \
  --environment-variables \
    SYNAPSE_SERVER_NAME=$SYNAPSE_SERVER_NAME \
    SYNAPSE_REPORT_STATS=no \
    POSTGRES_DB=$POSTGRES_DB \
    POSTGRES_USER=$POSTGRES_USER \
    POSTGRES_HOST=$POSTGRES_HOST \
    POSTGRES_PORT=$POSTGRES_PORT \
  --secure-environment-variables \
    POSTGRES_PASSWORD=$POSTGRES_PASSWORD

echo ""
echo "✅ Deployment Tamamlandı!"
echo ""
echo "🌐 Erişim Bilgileri:"
echo "  Matrix Synapse API: http://${SYNAPSE_SERVER_NAME}:8008"
echo "  Federation Port: http://${SYNAPSE_SERVER_NAME}:8448"
echo ""
echo "📊 Container Durumu:"
az container show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --query "{FQDN:ipAddress.fqdn,IP:ipAddress.ip,Status:instanceView.state}" \
  --output table

echo ""
echo "📝 Log'ları görmek için:"
echo "  az container logs --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME"
echo ""
echo "🗑️ Silmek için:"
echo "  az group delete --name $RESOURCE_GROUP --yes --no-wait"

