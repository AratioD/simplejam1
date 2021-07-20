FROM klakegg/hugo:0.83.1
FROM python:3.8.3-alpine

ARG UID
ARG GID

ENV USR=appuser
ENV GRP=appgroup
ENV PS1='`date "+%F %T"` \u@\h  \w \n\n  '
ENV PRODUCT_DIR="/opt/simplejam1"
ENV EDITOR="vim"

VOLUME $PRODUCT_DIR

# todo: should this be removed ?!
ARG BASE_PATH
ENV BASE_PATH ${BASE_PATH:-/}

# install OS utils
RUN apk update && apk upgrade && apk add --no-cache \
    bash binutils vim perl jq wget curl zip unzip busybox-extras su-exec sudo shadow

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
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
