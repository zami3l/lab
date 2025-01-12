FROM archlinux

########################
######### INIT #########
########################

# UPDATE And ADD dependence
RUN pacman -Syyu --noconfirm git wget man vim gzip sudo base-devel

# PATH
ARG PATH_INSTALL='/downloads'
ARG PATH_BIN='/usr/bin'
ARG PATH_WORDLIST='/usr/share/wordlist'
ARG PATH_ROOT='/root'
ARG PATH_BUILD='/home/build'
ARG PATH_OHMYZSH='/usr/share/oh-my-zsh'
ARG PATH_RANGER='/root/.config/ranger'

# CREATE user build for using packages AUR
RUN useradd -m build && \
    echo 'build ALL=NOPASSWD: ALL' >> /etc/sudoers

# ADD src BlackArch 
RUN mkdir -p ${PATH_INSTALL}
WORKDIR ${PATH_INSTALL}
RUN curl -O https://blackarch.org/strap.sh
ADD strap ${PATH_INSTALL}
RUN sha1sum -c strap
RUN chmod +x strap.sh && \
    sh ./strap.sh && \
    rm strap.sh

# ADD yay
RUN sudo -u build git clone --depth=1 https://aur.archlinux.org/yay.git ${PATH_BUILD}/yay && \
    cd ${PATH_BUILD}/yay && \
    sudo -u build makepkg -si --noconfirm && \
    yay -Syy

# ADD memo cmd
RUN curl -O -L https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz && \
    gunzip cheat-linux-amd64.gz && \
    cp cheat-linux-amd64 ${PATH_BIN}/cheat && \
    chmod +x ${PATH_BIN}/cheat
ADD conf.yml /root/.config/cheat/conf.yml
ADD .cheat /root/.cheat/personal

# ADD Zsh
RUN pacman -S --noconfirm zsh
RUN sudo -u build yay -S --noconfirm oh-my-zsh-git
RUN wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.zshrc && \
    wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.p10k.zsh && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${PATH_OHMYZSH}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${PATH_OHMYZSH}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${PATH_OHMYZSH}/themes/powerlevel10k

# ADD Ranger
RUN pacman -S --noconfirm ranger
RUN git clone --depth=1 https://github.com/fdw/ranger-autojump.git ${PATH_RANGER}/plugins/ranger-autojump && \
    git clone --depth=1 https://github.com/alexanderjeurissen/ranger_devicons.git ${PATH_RANGER}/plugins/ranger_devicons && \
    wget -P ${PATH_RANGER} https://raw.githubusercontent.com/Zami3l/linux/master/ranger/rc.conf && \
    sudo -u build yay -S --noconfirm autojump

# ADD Urxvt
RUN pacman -S rxvt-unicode && \
    sudo -u build yay -S --noconfirm ttf-hack && \
    wget -O ${PATH_ROOT}/.Xressources https://raw.githubusercontent.com/Zami3l/linux/master/rofi/.Xressources.urxvt

########################
######## TOOLS #########
########################

# Type : Wordlist
RUN mkdir -p ${PATH_WORDLIST} && \
    wget -P ${PATH_WORDLIST} https://github.com/praetorian-code/Hob0Rules/raw/master/wordlists/rockyou.txt.gz && \
    wget -P ${PATH_WORDLIST} https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt && \
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
RUN pacman -S --noconfirm bind-tools net-tools impacket

# Type : Other
RUN pacman -S --noconfirm hexyl hexedit
RUN sudo -u build yay -S --noconfirm android-backup-extractor-git

########################
######## CLEAN #########
########################

RUN rm -r ${PATH_INSTALL}/* && \
    rm -r ${PATH_BUILD}/* && \
    pacman -Sc --noconfirm && \
    rm -rf /tmp/*
WORKDIR ${PATH_ROOT}