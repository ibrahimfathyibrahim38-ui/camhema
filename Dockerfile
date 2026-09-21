# Dockerfile

# Script       : Hema Cam
# Author   : Daxxtropezz
# Github   : https://github.com/Daxxtropezz
# Email    : miraflores.john@gmail.com
# Messenger: https//m.me/Daxxtropezz
# Date     : 7-12-2024
# Main Language: Shell

# Download and import main images

# Operating system
FROM debian:latest

# Author info
LABEL MAINTAINER="https://github.com/Daxxtropezz/CamHacker"

# Working directory
WORKDIR /CamHacker/
# Add files 
ADD . /CamHacker

# Installing other packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl unzip wget -y
RUN apt-get install --no-install-recommends php -y
RUN apt-get clean

# Main command
CMD ["./ch.sh", "--no-update"]

## Wanna run it own? Try following commnads:

## "sudo docker build . -t daxxtropezz/camhacker:latest", "sudo docker run --rm -it daxxtropezz/pyphisher:latest"

## "sudo docker pull daxxtropezz/camhacker", "sudo docker run --rm -it daxxtropezz/camhacker"
