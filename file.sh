#!/bin/bash
set -e  # This tells the script to exit immediately if any command fails
# 1. Create a container file
cat <<EOF > Containerfile
FROM docker.io/amazonlinux:latest
RUN yum install httpd -y 
COPY ./src/ /var/www/html/
RUN chown -R apache:apache /var/www/html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EOF

# 2. Build the image
# Using sudo if required, or just podman if permissions are set
sudo docker build -t lms:latest -f Containerfile .

# 3. CLEANUP: Remove old container if it exists
echo "Cleaning up old containers..."
sudo docker stop lms-webserver || true
sudo docker rm lms-webserver || true

# 4. Run new container
echo "Starting new container..."
sudo docker run -d --name lms-webserver -p 8003:80 lms:latest

# 5. Verify
sudo docker ps -a

