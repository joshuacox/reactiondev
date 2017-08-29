FROM node:8-alpine

ENV OCTOSSH_UPDATED=20170828 \
BUILD_PACKAGES='sudo git wget openssh-client curl ca-certificates shadow bash'


RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && addgroup sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && gpasswd -a node sudo \
  && chown -R node:node /home/node

USER node
RUN curl https://install.meteor.com/ | sh
RUN sudo cp "/home/node/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor
RUN sudo npm i -g reaction-cli

WORKDIR /home/node

RUN /bin/bash -c "reaction init"

WORKDIR /home/node/reaction

CMD [ "reaction" ]
