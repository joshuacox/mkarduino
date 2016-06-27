FROM  gentoo/stage3-amd64
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV MKARDUINO 000

#Eventually needs to be a oneliner like this
#RUN emerge-webrsync ; \
#emerge --autounmask-write arduino ; \
#rm -Rf /portage

#locally  dev separately
RUN useradd git; mkdir /home/git;chown git. /home/git; \
mkdir /usr/portage

RUN emerge-webrsync
RUN for d in /etc/portage/package.*; do touch $d/zzz_autounmask; done
RUN emerge -avq sun-jre-bin crossdev layman git
RUN echo 'source /var/lib/layman/make.conf' >> /etc/portage/make.conf
RUN USE="-openmp" crossdev -t avr -s4 -S --without-headers
RUN emerge --autounmask-write arduino; etc-update --automode -5; emerge arduino
RUN rm -Rf /usr/portage

USER root
RUN cd /usr/local; \
wget -q https://www.arduino.cc/download.php?f=/arduino-nightly-linux64.tar.xz -O arduino-nightly.tar.xz ;  \
tar xvf arduino-nightly.tar.xz ; \
rm arduino-nightly.tar.xz ; \
cd /usr/local/bin ; \
ln -s /usr/local/arduino-nightly/arduino

RUN groupadd -r --gid 1001 arduino; useradd --uid 1001 -r -g arduino arduino; \
mkdir /home/arduino; chown arduino. /home/arduino; \
echo 'arduino ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers
USER arduino
RUN git clone https://github.com/sudar/Arduino-Makefile.git

CMD ["/usr/local/bin/arduino"]
