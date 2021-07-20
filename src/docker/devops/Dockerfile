FROM python:3.8.3-alpine

ARG UID
ARG GID

ENV USR=appuser
ENV GRP=appgroup
ENV PS1='`date "+%F %T"` \u@\h  \w \n\n  '
ENV PRODUCT_DIR="/opt/simplejam1"
ENV EDITOR="vim"

EXPOSE 1313

VOLUME $PRODUCT_DIR

# todo: should this be removed ?!
ARG BASE_PATH
ENV BASE_PATH ${BASE_PATH:-/}

# start ::: install OS utils
RUN apk update && apk upgrade && apk add --no-cache \
    bash binutils vim perl jq wget curl zip unzip busybox-extras su-exec sudo shadow \
    nodejs npm
# stop  ::: install OS utils

# start ::: install hugo
# Pass VERSION on build time
ARG VERSION="0.85.0"
ENV PACKAGE hugo_${VERSION}_Linux-64bit.tar.gz

RUN apk update && apk add \
	git openssh tar \
	&& rm -rf /var/cache/apk/*

WORKDIR /usr/bin

ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/${PACKAGE} /tmp
RUN set -x && tar xzvf "/tmp/${PACKAGE}" hugo -C /usr/bin \
	&& rm -fr "/tmp/${PACKAGE}"
# stop  ::: install hugo

RUN test -z $(getent group $GID | cut -d: -f1) || \
      groupmod -g $((GID+1000)) $(getent group $GID | cut -d: -f1)

# start ::: adding OS user and group
# START ::: create a group and user
RUN set -x ; addgroup -g "$GID" -S "$GRP" && \
	adduser \
	--disabled-password \
	-g "$GID" \
	-D \
	-s "/bin/bash" \
	-h "/home/$USR" \
	-u "$UID" \
	-G "$GRP" "$USR" && exit 0 ; exit 1


RUN echo "$USR ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# STOP  ::: create a group and user

USER $USR
ADD --chown=$USR:$GRP "." "/home/$USR/$PRODUCT_DIR"
# stop ::: adding OS usr and group

WORKDIR $PRODUCT_DIR
# todo: remove this one just makes sure that the container does not exit straighway ...
# CMD exec /bin/bash -c "$PRODUCT_DIR/src/bash/entrypoint.sh; trap : TERM INT; sleep infinity & wait"
# CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
# CMD ["/usr/bin/hugo" , "server" ,  "-D"]

ENTRYPOINT ["bash" , "/opt/simplejam1/src/bash/entrypoint.sh"]
