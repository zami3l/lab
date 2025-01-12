FROM archlinux

########################
######### INIT #########
########################

# UPDATE And ADD dependence
RUN pacman -Syyu --noconfirm git wget man vim gzip

# PATH
ARG PATH_INSTALL='/downloads'
ARG PATH_BIN='/usr/bin'
ARG PATH_WORDLIST='/usr/share/wordlist'

# ADD src BlackArch 
RUN mkdir -p ${PATH_INSTALL}
WORKDIR ${PATH_INSTALL}
RUN curl -O https://blackarch.org/strap.sh
ADD strap ${PATH_INSTALL}
RUN sha1sum -c strap
RUN chmod +x strap.sh && \
    sh ./strap.sh && \
    rm strap.sh

# ADD memo cmd
RUN curl -O -L https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz && \
    gunzip cheat-linux-amd64.gz && \
    cp cheat-linux-amd64 ${PATH_BIN}/cheat && \
    chmod +x ${PATH_BIN}/cheat
ADD conf.yml /root/.config/cheat/conf.yml
ADD .cheat /root/.cheat/personal

# Zsh
RUN pacman -S zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

########################
######## TOOLS #########
########################

# Type : Wordlist
RUN mkdir -p ${PATH_WORDLIST} && \
    wget -P ${PATH_WORDLIST} https://github.com/praetorian-code/Hob0Rules/raw/master/wordlists/rockyou.txt.gz && \
    gunzip ${PATH_WORDLIST}/rockyou.txt.gz

# Type : Scanner, Information-Gathering, Fingerprint, Footprinting
RUN pacman -S --noconfirm nmap gobuster netdiscover dirb traceroute nikto whois

# Type : Analyzer
RUN pacman -S --noconfirm pdf-parser perl-image-exiftool binwalk foremost pngcheck

# Type : Cracker
RUN pacman -S --noconfirm fcrackzip john

# Type : Exploitation
RUN pacman -S --noconfirm metasploit

# Type : Search Exploit
RUN pacman -S --noconfirm wordlistctl sploitctl

RUN git clone --depth=1 https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    ln -sf /opt/exploitdb/searchsploit /usr/bin/searchsploit

# Type : Networking
RUN pacman -S --noconfirm bind-tools net-tools

# Type : Other
RUN pacman -S --noconfirm hexyl hexedit