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
ARG PATH_ROOT='/root'
ARG PATH_OHMYZSH='/usr/share/oh-my-zsh/'
ARG PATH_RANGER='/root/.config/ranger'

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
RUN wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.zshrc && \
    wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.p10k.zsh && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${PATH_OHMYZSH}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${PATH_OHMYZSH}/plugins/zsh-autosuggestions

#Ranger
RUN pacman -S ranger
RUN git clone https://github.com/fdw/ranger-autojump.git ${PATH_RANGER}/plugins/ranger-autojump && \
    git clone https://github.com/alexanderjeurissen/ranger_devicons.git ${PATH_RANGER}/plugins/ranger_devicons && \
    echo "default_linemode devicons" >> ${PATH_RANGER}/rc.conf

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

########################
######## CLEAN #########
########################

RUN rm -r ${PATH_INSTALL} * && \
    pacman -Sc && \
    rm -rf /tmp/*
WORKDIR ${PATH_ROOT}