FROM reactioncommerce/base:devbuild

ENV REACTIONDEV_UPDATED=20170831 \
  REACTION_ROOT='/home/node/reaction'

RUN \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && groupadd -g 991 docker \
  && gpasswd -a node docker


#USER node
#WORKDIR /opt

#RUN curl https://install.meteor.com/ | sh \
#  &&  sudo cp "/home/node/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor \
#  &&  /bin/bash -c -l "sudo npm i -g reaction-cli"
#  &&  /bin/bash -c -l "reaction init"

#USER root
#RUN SUDO_FORCE_REMOVE=yes apt remove -yqq sudo
#RUN chown -R node:node /home/reaction
#USER node

#WORKDIR /opt/reaction
RUN mkdir -p /home/node/reaction \
  && chown node:node /home/node/reaction
WORKDIR /home/node/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
