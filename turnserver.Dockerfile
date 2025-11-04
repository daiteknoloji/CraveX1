# Coturn TURN Server Dockerfile for Railway
# Simplified version for Railway deployment

FROM coturn/coturn:latest

# Copy configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose TURN server ports
# Railway might only support TCP
EXPOSE 3478/tcp

# Start coturn with verbose logging
CMD ["turnserver", "-c", "/etc/turnserver.conf", "-v"]


