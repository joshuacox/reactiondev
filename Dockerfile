FROM node:latest

ENV BUILD_PACKAGES='git wget curl locales sudo bsdtar' \
  REACTION_ROOT='/home/node/reaction' \
  TOOL_NODE_FLAGS="--max-old-space-size=2048" \
  REACTIONDEV_UPDATED=20180807

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update && apt-get -qqy dist-upgrade \
  && apt-get -qqy --no-install-recommends install \
     $BUILD_PACKAGES \
  && echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen \
  && echo 'en_US ISO-8859-1'>>/etc/locale.gen \
  && echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen \
  && locale-gen \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && groupadd -g 991 docker \
  && gpasswd -a node docker \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

USER node
WORKDIR /home/node

ENV METEOR_VERSION 1.6.0.1
COPY install-meteor.sh /opt/install-meteor.sh
RUN  /bin/bash -l /opt/install-meteor.sh \
  && /bin/bash -c -l "sudo npm i -g reaction-cli"

ENV REACTION_BRANCH='master' \
  REACTION_EMAIL="admin@example.com" \
  REACTION_USER="admin" \
  REACTION_AUTH="p@ssw0rd"

RUN  /bin/bash -c -l "reaction init"
#RUN rm -Rf /opt/reaction
#WORKDIR /opt/reaction
#RUN  /bin/bash -c -l "reaction test"

USER root
RUN SUDO_FORCE_REMOVE=yes apt remove -yqq sudo
# RUN chown -R node:node /home/node
USER node

RUN mkdir -p /home/node/reaction
WORKDIR /home/node/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
