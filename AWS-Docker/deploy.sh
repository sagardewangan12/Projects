#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(pwd)"

echo "[1/6] Updating packages..."
sudo yum update -y

echo "[2/6] Installing Docker + Git + Docker Compose plugin..."
sudo yum install -y docker git docker-compose-plugin

echo "[3/6] Enabling & starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[4/6] Adding current user to docker group (takes effect after re-login)..."
sudo usermod -aG docker "$USER" || true

echo "[5/6] Verifying docker compose..."
docker compose version

# Optional: if repo isn't a git clone, continue anyway (intern-friendly)
if [ ! -d "$APP_DIR/.git" ]; then
  echo "[INFO] .git not found in $APP_DIR (not a cloned repo). Continuing deployment anyway..."
fi

echo "[6/6] Deploying with Docker Compose..."
cd "$APP_DIR"
docker-compose down || true
docker-compose up -d --build

echo " Deployment complete."
echo "Open in browser: http://13.62.103.141:8080"
