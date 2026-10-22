#!/bin/bash
# Install Docker on Ubuntu
set -eux

apt-get update -y
apt-get install -y ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
usermod -aG docker ubuntu

# Pull and run the web app image on first boot
# (later deploys are handled by the CI/CD pipeline via scripts/deploy.sh)
docker pull ${docker_image}

docker rm -f webapp-demo || true
docker run -d \
  --name webapp-demo \
  --restart unless-stopped \
  -p ${app_port}:80 \
  ${docker_image}
