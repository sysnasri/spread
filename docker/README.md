# Ansible Role: Docker Installation
=========

An Ansible Role that installs Docker on Ubuntu 



Role Variables
--------------
vars.yaml , you can add default containers that needs to be pulled from docker hub

    images_name: 
      - nasri/snapp:v1

If you are located in restricated area you can use proxy 

    proxy: 
       username: ""
       password: ""
       server: ""
       port: ""     

Pipe modules can be named here for deployment purpose  these are usefull when deploy application with docker compose and ansible 

    pip_modules:
        - pip
        - docker
        - docker-compose


you have option to chose shecan.ir name server for docker or just use http proxy which is more secure and faster. 


    nameserver:
      ns1: 8.8.8.8
      ns2: 4.2.2.4 

in some situation docker needs to be loged in. we could use ansible vault for credentials. 


    docker:
      username: ""
      password: ""                          



Example Playbook
----------------


    - hosts: Docker_Hosts
      vars_files:
        - vars/main.yml
      roles:
        - { role: sysnasri.docker }

License
-------

GPL

