# Deploy Python application with ansible as containers

  First of all you need to install ansible on a windows or linux machine, on windows you can use cygwin or WSL depends on OS version.  Here I am gonna explain on linux systems. 

## In your local linux machine install:

Debian based machine: 

    apt install git python3 python3-pip -y 

Redhat based machine: 

    yum install epel git -y 
    yum install python3 python3-pip -y

Then Clone the files  

    git clone https://github.com/sysnasri/spread
    cd spread ; sudo python3 -m pip install -r requirements.txt

Now Ansible is installed. you can check ansible version by issuing this command  *ansible --version*

# Quick start
This repo can be used to install docker and deploy appliction as container.

## Setup Ansible Inventory: 

  you can add target hosts in the inventory file located in  *./inventory/hosts.yml* there are samples for *group_vars* and *host_vars* as well. 

## Tags in playbook: 

Ansible role and playbook consist of a few tags for installtion of docker and application deployment, you don't need to play the whole role to just deploy application or install Docker. 

  To deploy All in one! 

    ansible-playbook main.yml -i inventory/hosts.yml -u root

  To deploy only containers! 

    ansible-playbook main.yml -i inventory/hosts.yml -u root  -t deployment  

   To Install only Docker on the server!

    ansible-playbook main.yml -i inventory/hosts.yml -u root  -t  install

# Playbook variables: 

#### Proxy example: 

sometimes you may need to setup proxy for docker and underlying services such as yum and apt if your servers do not have access to the Internet directly, you can set variables in *./vars/main.yml*

    proxy: 
        username: ""
        password: ""
        server: ""
        port: ""  

#### Default Docker images:

To pull docker images that you need on the host you can name them in *./vars/main.yml* with following variable example: 

    images_name: 
       - nginx
       - python

if these images are in private docker reposity you can see login inforamtion: 

    docker:
        username: ""
        password: ""       

    


# Application overview! 

There is a flask application that returns a simple Hello World! it consits of two Containers. Python Application container and Router Container which is nginx in this case to proxy pass requests to the backend application and finally a docker-compose to deploy two containers togehter. 

### Application DockerFile: 

    FROM python:3.8-slim-buster
    WORKDIR /opt/app
    COPY requirements.txt requirements.txt
    RUN apt update -y && apt install gcc -y && pip3 install -r requirements.txt
    COPY . /opt/app
    CMD [ "uwsgi", "--ini" , "app.ini"]


With *FROM* keyword it pulls a based python image and uses *WORKDIR* /opt/app as wokring direcoty. it means similar to change direcoty with cd in linux. requirements.txt file consist of a few python packages thus must be installed preior running the appliction. 
in line 4 with *RUN* command,  it's going to install gcc compiler and install pyton packageg, then with *COPY* all files in the host directory are going to copy to container directory which is /opt/app! 
Finally *CMD* is used to run python appliction. 

### Router DockerFile: 

    FROM nginx
    COPY default.conf /etc/nginx/conf.d/default.conf

Nginx can act as a Router, there is no much cofiguration needed to apply! 
A minimum nginx configuration looks like: 

        server {
        listen          80;
        server_name     spread.nasri.it www.spread.nasri.it;

        location / {
            proxy_pass  http://app:5000;
        }
    }

### Docker-compose.yml

it sounds a little scary but not at all! to put these two containers together and link them I have used docker-compse. 

    version: "3.3"
    networks:
    default_stack: null
    services:
    app:
        build:
        context: './application'

        container_name: application
        networks:
        default_stack: null
    router:
        build:
        context: './router'
        ports:
        - "80:80"
        container_name: nginx
        links:
        - "app"
        networks:
        default_stack: null

Docker-compse syntaxes are stright forward. In networks section I defined a default_stack network that can be used to put two containers in the same network ID. In Services I defined two services for my two containers, it first build images and then uses them. 

    docker-compse build  is used to pull base images and create new images. 
    docker-compse up -d   is used run these new images as container!
























    




 




