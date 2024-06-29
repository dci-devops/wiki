#!/bin/bash
sudo dnf upgrade -y                             #update all packages
sudo dnf install -y docker postgresql15         #install docker and postgresql
sudo usermod -aG docker $USER                   #add user to docker group
sudo systemctl start docker                     #start docker service
sudo systemctl enable docker                    #enable docker service
mkdir -p ~/wiki/config ~/wiki/data              #create directories for wiki
sudo docker network create internal-network     #create internal docker-network
admin_name=administrator                        #define db-Username
admin_pass=passwort1234                         #define db-Password
sudo docker run \                               #run postgres-container
    --name postgresdb \                         #name container
    --network internal-network \                #connect to internal-network
    -p 5432:5432 \                              #expose port 5432
    -e POSTGRES_DB=mydatabase \                 #define database name
    -e POSTGRES_USER=${admin_name} \            #define db-Username
    -e POSTGRES_PASSWORD=${admin_pass} \        #define db-Password
    -d postgres                                 #use postgres image
sudo docker run \                               #run wiki-container
    --name wiki \                               #name container
    --network internal-network \                #connect to internal-network
    -p 80:3000 \                                #expose port 80
    -e DB_TYPE=postgres \                       #use postgres as database
    -e DB_HOST=postgresdb \                     #connect to postgresdb container
    -e DB_PORT=5432 \                           #use port 5432
    -e DB_USER=${admin_name} \                  #use db-Username
    -e DB_PASS=${admin_pass} \                  #use db-Password
    -e DB_NAME=mydatabase \                     #use database name
    -v ~/wiki/config:/var/wiki/config \         #mount config-directory
    -v ~/wiki/data:/var/wiki/data \             #mount data-directory
    -d requarks/wiki:latest                     #use wiki image
