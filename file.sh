# Create a container file
cat <<EQF > Containerfile
FROM docker.io/amazonlinux:latest
RUN yum install httpd -y 
RUN echo "This webserver is craeted using jenkins" >> /var/www/html/index.html
EXPOSE 80
CMD "/usr/sbin/httpd" -D "FOREGROUND"
EQF

# Build a container image from file 
sudo podman build -t httpd:latest -f Containerfile .

# Verify the image 
sudo podman images 

# Run container from custome image 
sudo podman run -itd -p 8003:80 httpd:latest

# Verify Container 
sudo podman ps -a 
