#!/bin/bash

# Update system packages and install Docker and PostgreSQL 15
sudo dnf upgrade -y
sudo dnf install -y docker postgresql15

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to the Docker group
sudo usermod -aG docker ec2-user

# Create necessary directories
mkdir -p /home/ec2-user/wiki/config /home/ec2-user/wiki/data

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Clone the Git repository and navigate to the directory
git clone https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPOSITORY>.git /home/ec2-user/your-repository
cd /home/ec2-user/your-repository

# Bring up Docker Compose services
docker-compose up -d