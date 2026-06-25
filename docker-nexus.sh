#!/bin/bash

set -e

echo "==================================================="
echo " Docker & Nexus Installation (Ubuntu 26.04)"
echo "==================================================="

echo
echo "[1/12] Updating package index..."
sudo apt update

echo
echo "[2/12] Removing old Docker packages (if any)..."
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

echo
echo "[3/12] Installing prerequisites..."
sudo apt install -y \
ca-certificates \
curl \
gnupg \
lsb-release

echo
echo "[4/12] Creating Docker keyring..."
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo
echo "[5/12] Adding Docker repository..."

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

echo
echo "[6/12] Updating repositories..."
sudo apt update

echo
echo "[7/12] Installing Docker..."

sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

echo
echo "[8/12] Starting Docker..."

sudo systemctl enable docker
sudo systemctl restart docker

echo
echo "[9/12] Verifying Docker..."

docker --version
docker compose version

echo
echo "[10/12] Creating Nexus data directory..."

sudo mkdir -p /opt/nexus-data

sudo chown -R 200:200 /opt/nexus-data

echo
echo "[11/12] Downloading Nexus image..."

docker pull sonatype/nexus3:latest

echo
echo "[12/12] Starting Nexus..."

if docker ps -a --format '{{.Names}}' | grep -w nexus3 >/dev/null
then
    echo "Removing existing Nexus container..."
    docker rm -f nexus3
fi

docker run -d \
--name nexus3 \
--restart unless-stopped \
-p 8081:8081 \
-v /opt/nexus-data:/nexus-data \
sonatype/nexus3:latest

echo
echo "Waiting for Nexus to initialize..."
sleep 30

echo
echo "==================================================="
echo "Docker Containers"
echo "==================================================="

docker ps

echo
echo "==================================================="
echo "Docker Version"
echo "==================================================="

docker --version

echo
echo "==================================================="
echo "Docker Compose Version"
echo "==================================================="

docker compose version

echo
echo "==================================================="
echo "Nexus Logs (Last 20 Lines)"
echo "==================================================="

docker logs --tail 20 nexus3

echo
echo "==================================================="
echo "Access Nexus"
echo "==================================================="

echo "http://<PUBLIC-IP>:8081"

echo
echo "==================================================="
echo "Retrieve Initial Admin Password"
echo "==================================================="

echo "docker exec nexus3 cat /nexus-data/admin.password"

echo
echo "==================================================="
echo "Done!"
echo "==================================================="
