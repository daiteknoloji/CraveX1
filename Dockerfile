# Railway Dockerfile for Matrix Synapse
FROM matrixdotorg/synapse:latest

# Set environment for Railway
ENV SYNAPSE_SERVER_NAME=localhost \
    SYNAPSE_REPORT_STATS=no

# Ensure directories exist
RUN mkdir -p /data

# Copy config - Railway will mount /data as volume
COPY synapse-config/homeserver.yaml /homeserver.yaml

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8008/health || exit 1

EXPOSE 8008

# Use Synapse with generate config or run
CMD ["sh", "-c", "if [ ! -f /data/homeserver.yaml ]; then cp /homeserver.yaml /data/homeserver.yaml; fi && exec python -m synapse.app.homeserver -c /data/homeserver.yaml"]

