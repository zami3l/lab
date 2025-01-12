FROM archlinux:base-devel

########################
######### INIT #########
########################

# ADD configuration pacman
RUN sed -i 's/NoExtract  = usr\/share\/man\/*/#NoExtract  = usr\/share\/man\/*/g' /etc/pacman.conf && \
    sed -i 's/NoExtract  = usr\/share\/locale\/*/#NoExtract  = usr\/share\/locale\/*/g' /etc/pacman.conf
# PURGE pacman after install
RUN mkdir -p /etc/pacman.d/hooks
ADD scripts/clean_package_cache.hook /etc/pacman.d/hooks
# UPDATE 
RUN pacman -Syu --noconfirm
# Dependence
RUN pacman -S --noconfirm git wget man vim tmux pacman-contrib xclip python python-pip python-setuptools 

# PATH
ARG PATH_INSTALL='/downloads'
ARG PATH_SCRIPTS='/scripts'
ARG PATH_BIN='/usr/local/bin'
ARG PATH_WORDLIST='/usr/share/wordlists'
ARG PATH_ROOT='/root'
ARG PATH_BUILD='/home/build'
ARG PATH_OHMYZSH='/usr/share/oh-my-zsh'
ARG PATH_RANGER='/root/.config/ranger'
ARG PATH_TMUX_PLUGINS='/root/.tmux/plugins'

# ENV
ENV PATH="/usr/bin/vendor_perl:${PATH}"
ENV TERM=xterm-256color

# CREATE user build for using packages AUR
RUN useradd -m build && \
    echo 'build ALL=NOPASSWD: ALL' >> /etc/sudoers

# ADD src BlackArch 
RUN mkdir -p ${PATH_INSTALL}
WORKDIR ${PATH_INSTALL}
RUN curl -O https://blackarch.org/strap.sh
ADD strap ${PATH_INSTALL}
RUN sha1sum -c strap && \
    chmod +x strap.sh && \
    sh ./strap.sh && \
    rm strap.sh

# ADD yay
RUN sudo -u build git clone --depth=1 https://aur.archlinux.org/yay.git ${PATH_BUILD}/yay && \
    cd ${PATH_BUILD}/yay && \
    sudo -u build makepkg -si --noconfirm && \
    rm -rf ${PATH_BUILD}/.cache/*

# ADD Navi and Fzf
RUN sudo -u build yay -S --noconfirm --cleanafter navi && \
    pacman -S --noconfirm fzf && \
    git clone --depth=1 https://github.com/Zami3l/cheats.git ${PATH_ROOT}/.local/share/navi/cheats
ADD scripts/cheats_update scripts/run ${PATH_BIN}/
RUN chmod +x ${PATH_BIN}/cheats_update && \
    chmod +x ${PATH_BIN}/run

# ADD Zsh
RUN pacman -S --noconfirm zsh && \
    sudo -u build yay -S --noconfirm --cleanafter oh-my-zsh-git && \
    wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/dotfiles/master/zsh/.zshrc && \
    wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/dotfiles/master/zsh/.p10k.zsh && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${PATH_OHMYZSH}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${PATH_OHMYZSH}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${PATH_OHMYZSH}/themes/powerlevel10k

# ADD Ranger
RUN pacman -S --noconfirm ranger && \
    git clone --depth=1 https://github.com/fdw/ranger-autojump.git ${PATH_RANGER}/plugins/ranger-autojump && \
    git clone --depth=1 https://github.com/alexanderjeurissen/ranger_devicons.git ${PATH_RANGER}/plugins/ranger_devicons && \
    wget -P ${PATH_RANGER} https://raw.githubusercontent.com/Zami3l/dotfiles/master/ranger/rc.conf && \
    sudo -u build yay -S --noconfirm --cleanafter autojump

# ADD Postgresql
#RUN pacman -S --noconfirm postgresql
#ADD scripts/postgres.sh ${PATH_INSTALL}
#RUN sh ${PATH_INSTALL}/postgres.sh

# ADD Conf vim
RUN sudo -u build yay -S --noconfirm vim-plug && \
    wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/dotfiles/master/vim/.vimrc

# ADD Conf tmux
RUN mkdir -p .tmux/plugins && \
    git clone --depth=1 https://github.com/tmux-plugins/tpm ${PATH_TMUX_PLUGINS}/tpm && \
    git clone --depth=1 https://github.com/tmux-plugins/tmux-yank ${PATH_TMUX_PLUGINS}/tmux-yank && \
    wget -P ${PATH_ROOT} https://github.com/Zami3l/dotfiles/blob/master/tmux/.tmux.conf

########################
######## TOOLS #########
########################

# Type : Wordlist
RUN mkdir -p ${PATH_WORDLIST} && \
    wget -P ${PATH_WORDLIST} https://github.com/praetorian-code/Hob0Rules/raw/master/wordlists/rockyou.txt.gz && \
    wget -P ${PATH_WORDLIST} https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt && \
    gunzip ${PATH_WORDLIST}/rockyou.txt.gz

# Type : Scanner, Information-Gathering, Fingerprint, Footprinting
RUN pacman -S --noconfirm nmap gobuster netdiscover dirb traceroute nikto whois enum4linux enum4linux-ng smbmap h8mail 

# Type : Analyzer
RUN pacman -S --noconfirm pdf-parser perl-image-exiftool binwalk foremost pngcheck

# Type : Cracker
RUN pacman -S --noconfirm fcrackzip john hydra ncrack hashcat hashid hash-identifier

# Type : Exploitation
RUN pacman -S --noconfirm metasploit powersploit

# Type : Search Exploit
RUN pacman -S --noconfirm wordlistctl sploitctl && \
    git clone --depth=1 https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    ln -sf /opt/exploitdb/searchsploit /usr/bin/searchsploit

# Reversing
RUN pacman -S --noconfirm radare2

# Type : Networking
RUN pacman -S --noconfirm bind-tools net-tools impacket

# Type : Web
RUN pacman -S --noconfirm sqlmap dsss

# Type : Fuzzer
RUN pacman -S --noconfirm wfuzz

# Type : Database
RUN pacman -S --noconfirm mariadb

# Type : Other
RUN pacman -S --noconfirm hexyl hexedit gnu-netcat gtfo gtfoblookup && \
    sudo -u build yay -S --noconfirm --cleanafter android-backup-extractor-git

# Type : Scripts
RUN wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1 && \
    wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh && \
    wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh && \
    wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/CiscoCXSecurity/enum4linux/master/enum4linux.pl && \
    wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASbat/winPEAS.bat && \
    wget -P ${PATH_SCRIPTS} https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php

########################
######## CLEAN #########
########################

RUN rm -rf ${PATH_INSTALL}/* && \
    yay -Sc && \
    rm -rf /tmp/*
WORKDIR ${PATH_ROOT}
