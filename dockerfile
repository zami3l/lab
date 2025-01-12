FROM archlinux

########################
######### INIT #########
########################

# UPDATE And ADD dependence
RUN pacman -Syyu --noconfirm git wget man

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

# Type : Scanner
RUN pacman -S --noconfirm nmap gobuster netdiscover dirb

# Type : Exploitation
RUN pacman -S --noconfirm metasploit

# Type : Networking
RUN pacman -S --noconfirm bind-tools net-tools

# Type : Search
RUN pacman -S --noconfirm wordlistctl sploitctl

RUN git clone --depth=1 https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit

# Type : Other
RUN pacman -S --noconfirm hexyl hexedit
