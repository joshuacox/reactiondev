FROM node:8-alpine

ENV BUILD_PACKAGES='sudo git wget openssh-client curl ca-certificates shadow bash debootstrap perl' \
  REACTION_ROOT='/home/node/reaction' \
  REACTIONDEV_UPDATED=20170918

RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && addgroup sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && chown -R node:node /home/node \
  && groupadd -g 991 docker \
  && gpasswd -a node docker \
  && mkdir /opt/chroot
  RUN sudo debootstrap --arch=i386 wheezy ~/chroot http://http.debian.net/debian/

RUN for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 1 | sudo tee $i; done

RUN echo break; sleep 1

RUN \
  &&  tail -f /root/chroot/debootstrap/debootstrap.log & sudo chroot /opt/chroot /bin/bash -c "apt-get update \
  && apt-get install -yqq bsdtar \
  && apt-get -yqq autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/* "

  # && for i in /proc/sys/kernel/grsecurity/chroot_*; do echo 0 | sudo tee $i; done

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
