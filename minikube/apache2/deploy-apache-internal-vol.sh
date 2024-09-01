#!/bin/bash
# Deploy the appached web server container httpd from Docker Hub, using a customised
# image that includes the static web page

# Create the Dockerfile:
cat <<-EOF > Dockerfile
FROM docker.io/httpd:2.4
COPY ./initial-html/ /usr/local/apache2/htdocs/
EOF

# Create the website's index page
mkdir -p ./public-html
echo -e "Welcome to UTA.\nDocker is Cool" > ./public-html/index.html

# Build the custom image
podman build -t my-apache2:latest .

# Make sure the port you wish to use is open on this machine
# apache2 exposes port 80 in the container; we use 8080 on this machine's side
sudo firewall-cmd --add-port=8080/tcp --permanent 2> /dev/null
sudo firewall-cmd --reload 2> /dev/null

# Run the container; first stop any previous image
podman stop my-apache2-internal-vol 2> /dev/null && podman rm my-apache2-internal-vol 2>/dev/null
podman run --rm -dit --name my-apache2-internal-vol -p 8080:80 localhost/my-apache2:latest

# Open the website
echo -e "\nOpening the website from localhost:\n"
echo -e "curl -s localhost:8080\n"
curl -s localhost:8080

echo -e "\nOpening the website from oustide localhost (ie Windows host's browser):\n"
echo -e "curl -s 192.168.56.20:8080\n"
curl -s 192.168.56.20:8080  # replace ip with your server's ip address
