FROM node:8

ENV OCTOSSH_UPDATED=20170828 \
BUILD_PACKAGES='git wget curl locales sudo vim'

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update && apt-get -qqy dist-upgrade \
  && apt-get -qqy --no-install-recommends install \
     $BUILD_PACKAGES \
  && echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen \
  && echo 'en_US ISO-8859-1'>>/etc/locale.gen \
  && echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen \
  && locale-gen \
  && useradd reaction \
  && gpasswd -a reaction sudo \
  && mkdir -p /home/reaction \
  && chown -R reaction. /home/reaction \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

USER reaction
WORKDIR /home/reaction

RUN curl https://install.meteor.com/ | sh
RUN sudo cp "/home/reaction/.meteor/packages/meteor-tool/1.5.1/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor
RUN sudo npm i -g reaction-cli

#USER root
#RUN SUDO_FORCE_REMOVE=yes apt remove -yqq sudo
#RUN chown -R reaction:reaction /home/reaction
#USER reaction

RUN /bin/bash -c "reaction init"

WORKDIR /home/reaction/reaction

CMD [ "reaction" ]
