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
RUN emerge -avq sun-jre-bin crossdev layman
RUN echo 'source /var/lib/layman/make.conf' >> /etc/portage/make.conf
RUN USE="-openmp" crossdev -t avr -s4 -S --without-headers
RUN emerge --autounmask-write arduino; etc-update --automode -5; emerge arduino
RUN rm -Rf /usr/portage

WORKDIR /home/git

CMD ["/usr/bin/arduino"]
