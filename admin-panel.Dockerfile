# Admin Panel Dockerfile for Railway
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements (if exists) or install directly
COPY admin-panel-server.py .

# Install Python dependencies
RUN pip install --no-cache-dir \
    flask \
    flask-cors \
    matrix-nio \
    aiohttp \
    psycopg2-binary

# Expose port (Railway uses PORT env var, defaults to 8080)
EXPOSE 8080

# Environment variables will be set in Railway
ENV FLASK_APP=admin-panel-server.py
ENV PYTHONUNBUFFERED=1

# Start command
CMD ["python", "-u", "admin-panel-server.py"]

