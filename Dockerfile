FROM node:8-alpine

ENV BUILD_PACKAGES='sudo git wget openssh-client curl ca-certificates shadow bash' \
  REACTION_ROOT='/home/node/reaction' \
  REACTIONDEV_UPDATED=20170905


RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && addgroup sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && chown -R node:node /home/node \
  && groupadd -g 991 docker \
  && gpasswd -a node docker


USER node
WORKDIR /home/node
RUN sudo cp "/home/node/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor \
  && sudo npm i -g reaction-cli

WORKDIR /home/node/reaction
RUN mkdir -p /home/node/reaction \
  && chown node:node /home/node/reaction
WORKDIR /home/node/reaction

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
CMD [ "reaction" ]
