
# @see https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
#
# Version  1.0
#


# pull base image
FROM alpine:3.15

MAINTAINER William Yeh <william.pjyeh@gmail.com>


RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo


RUN echo "===> Adding Python runtime..."  && \
    apk --update add python3 py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python3-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi


RUN echo "===> Installing Ansible..."  && \
    pip install ansible


RUN echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pycrypto pywinrm         && \
    apk --update add sshpass openssh-client rsync

RUN echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

RUN echo "===> Installing nodejs..." && \
    apk add nodejs npm

RUN echo "===> Installing ext. tools..." && \
    apk add curl zip \
    mysql-client redis postgresql12-client mongodb-tools

RUN echo "===> Installing rclone..." && \
    apk add rclone restic

RUN echo "===> Installing node packages..." && \
    npm i @royalgarter/r-queue@2.4 -g

RUN echo "===> Installing rclone..." && \
    apk add openssh

RUN echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*

RUN echo "===> Installing pip..." && \
    pip install jmespath

RUN sed -i \
    's/^root:!:/root:*:/g' \
    /etc/shadow

RUN mkdir /keys

WORKDIR /mnt/data

COPY entrypoint.sh /
COPY sshd_config /etc/ssh/

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22/tcp

VOLUME ["/mnt/data","/keys"]

