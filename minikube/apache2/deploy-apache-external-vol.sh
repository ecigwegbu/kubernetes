#!/bin/bash
# Deploy the appached web server container httpd from Docker Hub,
# using using a local volume (directory) on the local machine to host a static web page
# The web page can be updated by updating the content of this local volume.

# Create the website's index page
mkdir -p ./public-html
echo -e "Welcome to UTA.\nDocker is Cool" > ./public-html/index.html

# Make sure the port you wish to use is open on this machine
# apache2 exposes port 80 in the container; we use 8081 on this machine's side
sudo firewall-cmd --add-port=8081/tcp --permanent &> /dev/null
sudo firewall-cmd --reload &> /dev/null

# Run the container; first stop any previous image
podman stop apache2-external-vol &> /dev/null && podman rm my-apache2-internal-vol &>/dev/null
podman run --rm -dit --name apache2-external-vol -p 8081:80 -v "$PWD"/public-html:/usr/local/apache2/htdocs/:Z docker.io/httpd:2.4

# Open the website
echo -e "\nOpening the website from localhost:\n"
echo -e "curl -s localhost:8081\n"
curl -s localhost:8081

echo -e "\nOpening the website from oustide localhost (ie Windows host's browser):\n"
echo -e "curl -s 192.168.56.20:8081\n"
curl -s 192.168.56.20:8081  # replace ip with your server's ip address
