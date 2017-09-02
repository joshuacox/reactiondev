FROM node:8

ENV REACTIONDEV_UPDATED=20170831 \
  BUILD_PACKAGES='git wget curl locales sudo vim' \
  REACTION_BRANCH='master' \
  REACTION_ROOT='/opt/reaction'

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
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*


USER node
WORKDIR /opt

RUN curl https://install.meteor.com/ | sh \
  &&  sudo cp "/home/node/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor \
  &&  /bin/bash -c -l "sudo npm i -g reaction-cli" \
  &&  /bin/bash -c -l "reaction init -b $REACTION_BRANCH"

#USER root
#RUN SUDO_FORCE_REMOVE=yes apt remove -yqq sudo
#RUN chown -R node:node /home/reaction
#USER node

WORKDIR /opt/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
