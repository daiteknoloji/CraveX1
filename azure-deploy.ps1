# Azure Deployment Script - Cravex v5 (PowerShell)
# Bu script Matrix Synapse'i Azure Container Instances'a deploy eder

Write-Host "🚀 Cravex v5 - Azure Deployment" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Değişkenler
$RESOURCE_GROUP = "cravex-rg"
$LOCATION = "westeurope"
$CONTAINER_NAME = "matrix-synapse"
$DNS_NAME = "cravex-matrix"
$IMAGE = "matrixdotorg/synapse:latest"

# PostgreSQL (Supabase)
$POSTGRES_HOST = "db.tsmewoznjeixsojqqlud.supabase.co"
$POSTGRES_PORT = "5432"
$POSTGRES_DB = "postgres"
$POSTGRES_USER = "postgres"
$POSTGRES_PASSWORD = "1A6qjJG41TMjee6z"

# Synapse
$SYNAPSE_SERVER_NAME = "$DNS_NAME.$LOCATION.azurecontainer.io"

Write-Host ""
Write-Host "📋 Deployment Detayları:" -ForegroundColor Yellow
Write-Host "  Resource Group: $RESOURCE_GROUP"
Write-Host "  Location: $LOCATION"
Write-Host "  DNS: $SYNAPSE_SERVER_NAME"
Write-Host ""

# Azure CLI kontrolü
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI bulunamadı!" -ForegroundColor Red
    Write-Host "Kurulum: https://aka.ms/installazurecli" -ForegroundColor Yellow
    exit 1
}

# Login kontrolü
Write-Host "🔐 Azure'a giriş yapılıyor..." -ForegroundColor Cyan
az account show 2>$null
if ($LASTEXITCODE -ne 0) {
    az login
}

# 1. Resource Group Oluştur
Write-Host ""
Write-Host "1️⃣ Resource Group oluşturuluyor..." -ForegroundColor Green
az group create `
  --name $RESOURCE_GROUP `
  --location $LOCATION

# 2. Synapse Container Deploy
Write-Host ""
Write-Host "2️⃣ Matrix Synapse container deploy ediliyor..." -ForegroundColor Green
az container create `
  --resource-group $RESOURCE_GROUP `
  --name $CONTAINER_NAME `
  --image $IMAGE `
  --dns-name-label $DNS_NAME `
  --ports 8008 8448 `
  --cpu 2 `
  --memory 4 `
  --environment-variables `
    SYNAPSE_SERVER_NAME=$SYNAPSE_SERVER_NAME `
    SYNAPSE_REPORT_STATS=no `
    POSTGRES_DB=$POSTGRES_DB `
    POSTGRES_USER=$POSTGRES_USER `
    POSTGRES_HOST=$POSTGRES_HOST `
    POSTGRES_PORT=$POSTGRES_PORT `
  --secure-environment-variables `
    POSTGRES_PASSWORD=$POSTGRES_PASSWORD

Write-Host ""
Write-Host "✅ Deployment Tamamlandı!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Erişim Bilgileri:" -ForegroundColor Cyan
Write-Host "  Matrix Synapse API: http://${SYNAPSE_SERVER_NAME}:8008" -ForegroundColor White
Write-Host "  Federation Port: http://${SYNAPSE_SERVER_NAME}:8448" -ForegroundColor White
Write-Host ""
Write-Host "📊 Container Durumu:" -ForegroundColor Yellow
az container show `
  --resource-group $RESOURCE_GROUP `
  --name $CONTAINER_NAME `
  --query "{FQDN:ipAddress.fqdn,IP:ipAddress.ip,Status:instanceView.state}" `
  --output table

Write-Host ""
Write-Host "📝 Yararlı Komutlar:" -ForegroundColor Yellow
Write-Host "  Log görüntüle:" -ForegroundColor White
Write-Host "    az container logs --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME" -ForegroundColor Gray
Write-Host ""
Write-Host "  Container'ı yeniden başlat:" -ForegroundColor White
Write-Host "    az container restart --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME" -ForegroundColor Gray
Write-Host ""
Write-Host "  Tümünü sil:" -ForegroundColor White
Write-Host "    az group delete --name $RESOURCE_GROUP --yes --no-wait" -ForegroundColor Gray

