FROM node:8-alpine

ENV BUILD_PACKAGES='sudo git wget openssh-client curl ca-certificates shadow bash bsdtar debootstrap' \
  REACTION_ROOT='/home/node/reaction' \
  REACTIONDEV_UPDATED=20170910

RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && addgroup sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && chown -R node:node /home/node \
  && groupadd -g 991 docker \
  && gpasswd -a node docker \
  && for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 0 | sudo tee $i; done \
  && mkdir /opt/chroot \
  && sudo debootstrap --arch=i386 wheezy ~/chroot http://http.debian.net/debian/ \
  && for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 1 | sudo tee $i; done \
  && sudo chroot /opt/chroot /bin/bash -c "apt-get install -y bsdtar"


USER node
WORKDIR /opt

ENV METEOR_VERSION 1.5.1
COPY install-meteor.sh /opt/install-meteor.sh
RUN  /bin/bash -l /opt/install-meteor.sh \
  && /bin/bash -c -l "sudo npm i -g reaction-cli"
#RUN  /bin/bash -c -l "reaction init"
#RUN rm -Rf /opt/reaction
#WORKDIR /opt/reaction
#RUN  /bin/bash -c -l "reaction test"

USER root
RUN apk del sudo
USER node

RUN mkdir -p /home/node/reaction
WORKDIR /home/node/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
