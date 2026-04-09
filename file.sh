#!/bin/bash
set -e  # This tells the script to exit immediately if any command fails
# 1. Create a container file
cat <<EOF > Containerfile
FROM docker.io/amazonlinux:latest
RUN yum install httpd -y 
RUN echo "This webserver is created using jenkins" >> /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EOF

# 2. Build the image
# Using sudo if required, or just podman if permissions are set
sudo podman build -t httpd:latest -f Containerfile .

# 3. CLEANUP: Remove old container if it exists
echo "Cleaning up old containers..."
sudo podman stop lms-webserver || true
sudo podman rm lms-webserver || true

# 4. Run new container
echo "Starting new container..."
sudo podman run -d --name lms-webserver -p 8003:80 httpd:latest

# 5. Verify
sudo podman ps -a
