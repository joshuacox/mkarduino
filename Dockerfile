FROM debian:jessie
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV MKARDUINO 000
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV MKARDUINO_UPDATED 20161007

RUN apt-get -qq update; \
apt-get -qqy dist-upgrade ; \
apt-get -qqy --no-install-recommends install locales \
arduino arduino-core arduino-mk gcc-avr avr-libc avrdude build-essential \
git sudo procps ca-certificates wget pwgen supervisor uucp; \
echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen ; \
echo 'en_US ISO-8859-1'>>/etc/locale.gen ; \
echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen ; \
locale-gen ; \
apt-get -y autoremove ; \
apt-get clean ; \
rm -Rf /var/lib/apt/lists/*

RUN cd /usr/local; \
wget -q http://download.arduino.org/IDE/1.7.11/arduino-1.7.11.org-linux64.tar.xz -O arduino-nightly.tar.xz ;  \
tar xvf arduino-nightly.tar.xz ; \
rm arduino-nightly.tar.xz ; \
cd /usr/local/bin ; \
rm -f arduino ; \
ln -s /usr/local/arduino-1.7.11-linux64/arduino


RUN groupadd -r --gid 1001 arduino; useradd --uid 1001 -r -g arduino arduino; \
gpasswd -a arduino dialout ; \
mkdir /home/arduino; chown -R arduino. /home/arduino; \
echo 'arduino ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers
RUN groupadd -g 14 archuucp; gpasswd -a arduino archuucp
USER arduino
WORKDIR /home/arduino
RUN git clone https://github.com/sudar/Arduino-Makefile.git


USER arduino

CMD ["/usr/local/bin/arduino"]
