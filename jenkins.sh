#!/bin/bash

set -e

echo "======================================================="
echo "      Jenkins Installation - Ubuntu 26.04 LTS"
echo "======================================================="

echo
echo "[1/10] Updating package index..."
sudo apt update

echo
echo "[2/10] Removing old Jenkins repository..."
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc

echo
echo "[3/10] Installing required packages..."
sudo apt install -y \
curl \
wget \
gnupg \
ca-certificates \
fontconfig \
software-properties-common

echo
echo "[4/10] Installing OpenJDK 21..."
sudo apt install -y openjdk-21-jdk

echo
echo "[5/10] Verifying Java..."
java -version

echo
echo "[6/10] Downloading Jenkins 2026 GPG Key..."

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
| sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null

echo
echo "[7/10] Adding Jenkins Repository..."

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

echo
echo "[8/10] Updating package index..."
sudo apt update

echo
echo "[9/10] Installing Jenkins..."
sudo apt install -y jenkins

echo
echo "[10/10] Configuring Jenkins to use Java 21..."

JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"

sudo mkdir -p /etc/systemd/system/jenkins.service.d

sudo tee /etc/systemd/system/jenkins.service.d/override.conf >/dev/null <<EOF
[Service]
Environment="JAVA_HOME=$JAVA_HOME"
Environment="PATH=$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EOF

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo
echo "Waiting for Jenkins to start..."
sleep 15

echo
echo "======================================================="
echo "Java Version"
echo "======================================================="
java -version

echo
echo "======================================================="
echo "Jenkins Version"
echo "======================================================="
jenkins --version

echo
echo "======================================================="
echo "Jenkins Service Status"
echo "======================================================="
sudo systemctl --no-pager status jenkins

echo
echo "======================================================="
echo "Checking Port 8080"
echo "======================================================="
sudo ss -tulnp | grep 8080 || true

echo
echo "======================================================="
echo "Initial Admin Password"
echo "======================================================="

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Password file not found."
    echo "Check Jenkins logs:"
    echo "sudo journalctl -u jenkins -n 100 --no-pager"
fi

echo
echo "======================================================="
echo "Installation Completed"
echo "======================================================="
echo "Access Jenkins:"
echo
echo "http://<YOUR_PUBLIC_IP>:8080"
echo