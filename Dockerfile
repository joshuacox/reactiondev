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
RUN cp "/root/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor; mv /root/.meteor /home/reaction/; chown -R reaction:reaction /home/reaction
RUN npm i -g reaction-cli

USER reaction
WORKDIR /home/reaction

#RUN stat /home/reaction/.meteor/packages/meteor-tool/.1.5.1.puot9a++os.linux.x86_64+web.browser+web.cordova/mt-os.linux.x86_64/dev_bundle/bin/node
RUN /bin/bash -c "reaction init"

RUN chown -R reaction:reaction /home/reaction
WORKDIR /home/reaction/reaction

CMD [ "reaction" ]
