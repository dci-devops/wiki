#!/bin/bash
sudo dnf upgrade -y                        
sudo dnf install -y docker postgresql15    
sudo usermod -aG docker $USER              
sudo systemctl start docker                
sudo systemctl enable docker               
mkdir -p ~/wiki/config ~/wiki/data         
sudo docker network create internal-network
admin_name=administrator                   
admin_pass=passwort1234                    
sudo docker run \
    --name postgresdb \
    --network internal-network \
    -p 5432:5432 \
    -e POSTGRES_DB=mydatabase \
    -e POSTGRES_USER=${admin_name} \
    -e POSTGRES_PASSWORD=${admin_pass} \
    -d postgres   
sudo docker run \
    --name wiki \
    --network internal-network \
    -p 80:3000 \
    -e DB_TYPE=postgres \
    -e DB_HOST=postgresdb \
    -e DB_PORT=5432 \
    -e DB_USER=${admin_name} \
    -e DB_PASS=${admin_pass} \
    -e DB_NAME=mydatabase \
    -v ~/wiki/config:/var/wiki/config \
    -v ~/wiki/data:/var/wiki/data \
    -d requarks/wiki:latest        
