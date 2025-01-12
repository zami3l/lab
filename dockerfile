FROM archlinux

########################
######### INIT #########
########################
RUN pacman -Syyu git --noconfirm

# PATH
ARG PATH="/downloads"

# ADD src BlackArch 
RUN mkdir -p ${PATH}
WORKDIR ${PATH}
RUN curl -O https://blackarch.org/strap.sh
ADD strap ${PATH}
RUN sha1sum -c strap
RUN chmod +x strap.sh && \
    sh ./strap.sh && \
    rm strap.sh

# ADD memo cmd
RUN curl -O -L https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz && \
    gunzip cheat-linux-amd64.gz && \
    chmod +x cheat-linux-amd64 && \
    yes yes | ./cheat-linux-amd64


########################
######## TOOLS #########
########################

#Information-Gathering
RUN pacman -S --noconfirm nmap gobuster

#Pentest framework
RUN pacman -S --noconfirm metasploit

#Other

RUN pacman -S --noconfirm hexyl hexedit