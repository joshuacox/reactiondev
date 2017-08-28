FROM node:8-alpine

ENV OCTOSSH_UPDATED=20170828 \
BUILD_PACKAGES='git wget openssh-client curl ca-certificates shadow bash'

RUN apk update && apk upgrade \
  && apk add --no-cache $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /home/reaction \
  && adduser -S reaction \
  && addgroup reaction \
  && chown -R reaction. /home/reaction


RUN curl https://install.meteor.com/ | sh
RUN cp "/root/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor
RUN npm i -g reaction-cli

USER reaction
WORKDIR /home/reaction

RUN reaction init

WORKDIR /home/reaction/reaction

CMD [ "reaction" ]
