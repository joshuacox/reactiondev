FROM node:8.4

ENV BUILD_PACKAGES='git wget curl locales sudo' \
  REACTION_ROOT='/home/node/reaction' \
  REACTIONDEV_UPDATED=20170906

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update && apt-get -qqy dist-upgrade \
  && apt-get -qqy --no-install-recommends install \
     $BUILD_PACKAGES \
  && echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen \
  && echo 'en_US ISO-8859-1'>>/etc/locale.gen \
  && echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen \
  && locale-gen \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && chown -R node:node /opt \
  && gpasswd -a node sudo \
  && groupadd -g 991 docker \
  && gpasswd -a node docker \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*


USER node
WORKDIR /opt

RUN curl https://install.meteor.com/ | sh \
  &&  sudo cp "/home/node/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor \
  &&  /bin/bash -c -l "sudo npm i -g reaction-cli"

#USER root
#RUN SUDO_FORCE_REMOVE=yes apt remove -yqq sudo
#RUN chown -R node:node /home/node
#USER node

RUN mkdir -p /home/node/reaction \
  && chown node:node /home/node/reaction
WORKDIR /home/node/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
