# Railway için basitleştirilmiş Dockerfile
FROM matrixdotorg/synapse:latest

# Gerekli dizinleri oluştur
RUN mkdir -p /data /config /data/media_store

# Config template kopyala
COPY synapse-config/homeserver.yaml /config/homeserver.yaml.template

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8008/health || exit 1

EXPOSE 8008

# Startup script
CMD ["sh", "-c", "\
  if [ ! -f /data/homeserver.yaml ]; then \
    echo 'Generating initial config...'; \
    python -m synapse.app.homeserver \
      --server-name=${RAILWAY_PUBLIC_DOMAIN:-localhost} \
      --config-path=/data/homeserver.yaml \
      --generate-config \
      --report-stats=no; \
  fi && \
  echo 'Starting Synapse...'; \
  python -m synapse.app.homeserver -c /data/homeserver.yaml \
"]

