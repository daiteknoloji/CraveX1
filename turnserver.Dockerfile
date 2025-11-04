# Coturn TURN Server Dockerfile for Railway
FROM coturn/coturn:latest

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose TURN server ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 49152-65535/udp

# Start coturn
CMD ["turnserver", "-c", "/etc/turnserver.conf"]

