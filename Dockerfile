FROM joshuacox/archlinux
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV MKARDUINO 000

COPY pacman.conf /etc/pacman.conf
RUN groupadd -r yaourt; useradd -r -g yaourt yaourt; groupadd -r arduino; useradd -r -g arduino arduino; \
echo 'arduino ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers
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

RUN pacman -Syu --noconfirm --needed base-devel wget lib32-libxt libxt jre7-openjdk mesa-libgl

RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/arduino.tar.gz; tar zxvf arduino.tar.gz;useradd arduino; mv arduino /home/;chown arduino. /home/arduino
RUN mkdir /tmp/yaourt
RUN chown -R yaourt:yaourt /tmp/yaourt
RUN pacman --noconfirm -Syyu
USER arduino
WORKDIR /home/arduino
RUN makepkg --noconfirm -sri

WORKDIR /home/git

CMD ["/usr/bin/arduino"]


#WORKDIR /tmp/yaourt
#RUN git clone https://aur.archlinux.org/package-query.git
#RUN git clone https://aur.archlinux.org/yaourt.git
#WORKDIR /tmp/yaourt/package-query
#RUN makepkg -si
#WORKDIR /tmp/yaourt/yaourt
#RUN makepkg -si
