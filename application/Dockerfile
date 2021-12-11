FROM python:3.8-slim-buster
WORKDIR /opt/app
COPY requirements.txt requirements.txt
RUN apt update -y && apt install gcc -y && pip3 install -r requirements.txt
COPY . /opt/app
CMD [ "uwsgi", "--ini" , "app.ini"]