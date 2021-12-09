
# @see https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
#
# Version  1.0
#


# pull base image
FROM restic/restic:0.12.0 as restic

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


RUN echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               


RUN echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

COPY --from=restic /usr/bin/restic /usr/bin/restic

WORKDIR /mnt/data

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /mnt/data

