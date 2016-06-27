FROM joshuacox/archlinux
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV MKARDUINO 000

COPY pacman.conf /etc/pacman.conf
RUN groupadd -r yaourt; useradd -r -g yaourt yaourt
#RUN dirmngr </dev/null
#RUN pacman-key --init
#RUN pacman-key --populate archlinux
#RUN pacman-key --refresh-keys

#RUN pacman --noconfirm -S archlinux-keyring ; \
#pacman --noconfirm -Syu
#RUN pacman --noconfirm -Syyu

#RUN pacman -Sy; \
#pacman --noconfirm -Rdd dirmngr

#RUN pacman-db-upgrade
#RUN pacman --noconfirm -Syyu
#RUN pacman -S --noconfirm dirmngr
#RUN pacman --noconfirm -Sy
#RUN pacman --noconfirm -Syu

#RUN pacman -S --noconfirm harfbuzz

RUN pacman -Syu --noconfirm --needed git base-devel wget lib32-libxtst libxtst lib32-libxt libxt jre7-openjdk mesa-libgl ; \
mkdir /tmp/yaourt ; \
chown -R yaourt:yaourt /tmp/yaourt ; \
pacman --noconfirm -Syyu
RUN groupadd -r --gid 1001 arduino; useradd --uid 1001 -r -g arduino arduino; \
mkdir /home/arduino; chown arduino. /home/arduino; \
echo 'arduino ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers
USER arduino
WORKDIR /home/arduino
RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/arduino.tar.gz; \
tar zxvf arduino.tar.gz; \
rm arduino.tar.gz; \
cd arduino; \
makepkg --noconfirm -sri; \
cd /home/arduino; \
rm -Rf arduino
RUN git clone https://github.com/sudar/Arduino-Makefile.git
USER root
RUN cd /usr/local; \
wget -q https://www.arduino.cc/download.php?f=/arduino-nightly-linux64.tar.xz -O arduino-nightly.tar.xz ;  \
tar xvf arduino-nightly.tar.xz ; \
rm arduino-nightly.tar.xz ; \
cd /usr/local/bin ; \
ln -s /usr/local/arduino-nightly/arduino

USER arduino


CMD ["/usr/local/bin/arduino"]


#WORKDIR /tmp/yaourt
#RUN git clone https://aur.archlinux.org/package-query.git
#RUN git clone https://aur.archlinux.org/yaourt.git
#WORKDIR /tmp/yaourt/package-query
#RUN makepkg -si
#WORKDIR /tmp/yaourt/yaourt
#RUN makepkg -si
