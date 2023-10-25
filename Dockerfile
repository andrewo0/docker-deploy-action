FROM python:3.8.3-slim-buster

LABEL "name"="Docker Deploy Action"
LABEL "maintainer"="Andrew Osenga <andrew@devmonq.com>"

LABEL "com.github.actions.name"="Docker Deploy Action"
LABEL "com.github.actions.description"="Deploy your docker image"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apt-get update -y && \
  apt-get install -y ca-certificates openssh-client openssl sshpass

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN mkdir -p /opt/tools

COPY entrypoint.sh /opt/tools/entrypoint.sh
RUN chmod +x /opt/tools/entrypoint.sh

COPY app.py /opt/tools/app.py
RUN chmod +x /opt/tools/app.py

ENTRYPOINT ["/opt/tools/entrypoint.sh"]