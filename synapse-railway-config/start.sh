#!/bin/bash
set -e

echo "🚀 Starting Matrix Synapse on Railway..."

# Environment variables kontrolü
if [ -z "$POSTGRES_HOST" ]; then
    echo "❌ ERROR: POSTGRES_HOST not set!"
    exit 1
fi

# Synapse data dizini
DATA_DIR="/data"
mkdir -p $DATA_DIR

# homeserver.yaml'ı kopyala ve environment variables ile güncelle
cp /config/homeserver.yaml $DATA_DIR/homeserver.yaml

# Server name güncelle
if [ ! -z "$SYNAPSE_SERVER_NAME" ]; then
    sed -i "s|server_name: \"matrix-synapse-production.up.railway.app\"|server_name: \"$SYNAPSE_SERVER_NAME\"|g" $DATA_DIR/homeserver.yaml
    sed -i "s|https://matrix-synapse-production.up.railway.app/|https://$SYNAPSE_SERVER_NAME/|g" $DATA_DIR/homeserver.yaml
fi

# Web client location güncelle
if [ ! -z "$WEB_CLIENT_LOCATION" ]; then
    sed -i "s|https://synapse-admin-ui-production.up.railway.app|$WEB_CLIENT_LOCATION|g" $DATA_DIR/homeserver.yaml
fi

# PostgreSQL ayarlarını güncelle
sed -i "s|user: postgres|user: $POSTGRES_USER|g" $DATA_DIR/homeserver.yaml
sed -i "s|password: changeme|password: $POSTGRES_PASSWORD|g" $DATA_DIR/homeserver.yaml
sed -i "s|database: railway|database: $POSTGRES_DB|g" $DATA_DIR/homeserver.yaml
sed -i "s|host: localhost|host: $POSTGRES_HOST|g" $DATA_DIR/homeserver.yaml
sed -i "s|port: 5432|port: $POSTGRES_PORT|g" $DATA_DIR/homeserver.yaml

# Signing key oluştur (yoksa)
if [ ! -f "$DATA_DIR/signing.key" ]; then
    echo "🔑 Generating signing key..."
    python3 -m synapse.app.homeserver \
        --config-path=$DATA_DIR/homeserver.yaml \
        --generate-keys
fi

# Log config oluştur
cat > $DATA_DIR/log.config <<EOF
version: 1
formatters:
  precise:
    format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(message)s'
handlers:
  console:
    class: logging.StreamHandler
    formatter: precise
root:
  level: INFO
  handlers: [console]
loggers:
  synapse.storage.SQL:
    level: INFO
EOF

echo "✅ Configuration complete!"
echo "📍 Server: $SYNAPSE_SERVER_NAME"
echo "🗄️  Database: $POSTGRES_HOST:$POSTGRES_PORT"
echo ""
echo "🚀 Starting Synapse..."

# Synapse başlat
exec python3 -m synapse.app.homeserver -c $DATA_DIR/homeserver.yaml

