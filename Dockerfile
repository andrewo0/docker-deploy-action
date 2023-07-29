FROM docker:stable

LABEL "name"="Docker Deploy Action"
LABEL "maintainer"="Andrew Osenga <andrew@devmonq.com>"

LABEL "com.github.actions.name"="Docker Deploy Action"
LABEL "com.github.actions.description"="Deploy your docker image"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apk --no-cache add sshpass
RUN apk --no-cache add openssh-client

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]