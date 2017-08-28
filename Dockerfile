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


USER reaction
RUN curl https://install.meteor.com/ | sh
RUN cp "/home/reaction/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/local/bin/meteor
RUN npm i -g reaction-cli

WORKDIR /home/reaction

RUN stat /root/.meteor/packages/meteor-tool/.1.5.1.puot9a++os.linux.x86_64+web.browser+web.cordova/mt-os.linux.x86_64/dev_bundle/bin/node
RUN /bin/bash -c "reaction init"

RUN chown -R reaction:reaction /home/reaction
WORKDIR /home/reaction/reaction

CMD [ "reaction" ]
