FROM archlinux

########################
######### INIT #########
########################

# UPDATE And ADD dependence
RUN pacman -Syyu --noconfirm git wget man vim gzip sudo

# PATH
ARG PATH_BIN='/usr/bin'
ARG PATH_WORDLIST='/usr/share/wordlist'
ARG PATH_ROOT='/root'
ARG PATH_BUILD='/home/build'
ARG PATH_OHMYZSH='/usr/share/oh-my-zsh/'
ARG PATH_RANGER='/root/.config/ranger'

# CREATE user build for using packages AUR
RUN useradd -m build && \
    echo 'build ALL=NOPASSWD: ALL' >> /etc/sudoers

# ADD src BlackArch 
RUN mkdir -p ${PATH_BUILD}
WORKDIR ${PATH_BUILD}
RUN curl -O https://blackarch.org/strap.sh
ADD strap ${PATH_BUILD}
RUN sha1sum -c strap
RUN chmod +x strap.sh && \
    sh ./strap.sh && \
    rm strap.sh

# USER build
USER build

# ADD memo cmd
RUN curl -O -L https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz && \
    gunzip cheat-linux-amd64.gz && \
    sudo cp cheat-linux-amd64 ${PATH_BIN}/cheat && \
    sudo chmod +x ${PATH_BIN}/cheat
ADD conf.yml /root/.config/cheat/conf.yml
ADD .cheat /root/.cheat/personal

# Add Zsh
RUN sudo pacman -S --noconfirm zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sudo wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.zshrc && \
    sudo wget -P ${PATH_ROOT} https://raw.githubusercontent.com/Zami3l/linux/master/zsh/.p10k.zsh && \
    sudo git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${PATH_OHMYZSH}/plugins/zsh-syntax-highlighting && \
    sudo git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${PATH_OHMYZSH}/plugins/zsh-autosuggestions

# ADD Ranger
RUN sudo pacman -S --noconfirm ranger
RUN sudo git clone --depth=1 https://github.com/fdw/ranger-autojump.git ${PATH_RANGER}/plugins/ranger-autojump && \
    sudo git clone --depth=1 https://github.com/alexanderjeurissen/ranger_devicons.git ${PATH_RANGER}/plugins/ranger_devicons
    #sudo git clone https://raw.githubusercontent.com/Zami3l/linux/master/ranger/rc.conf ${PATH_RANGER}/rc.conf

########################
######## TOOLS #########
########################

# Type : Wordlist
RUN sudo mkdir -p ${PATH_WORDLIST} && \
    sudo wget -P ${PATH_WORDLIST} https://github.com/praetorian-code/Hob0Rules/raw/master/wordlists/rockyou.txt.gz && \
    sudo gunzip ${PATH_WORDLIST}/rockyou.txt.gz

# Type : Scanner, Information-Gathering, Fingerprint, Footprinting
RUN sudo pacman -S --noconfirm nmap gobuster netdiscover dirb traceroute nikto whois

# Type : Analyzer
RUN sudo pacman -S --noconfirm pdf-parser perl-image-exiftool binwalk foremost pngcheck

# Type : Cracker
RUN sudo pacman -S --noconfirm fcrackzip john

# Type : Exploitation
RUN sudo pacman -S --noconfirm metasploit

# Type : Search Exploit
RUN sudo pacman -S --noconfirm wordlistctl sploitctl

RUN sudo git clone --depth=1 https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    sudo ln -sf /opt/exploitdb/searchsploit /usr/bin/searchsploit

# Type : Networking
RUN sudo pacman -S --noconfirm bind-tools net-tools

# Type : Other
RUN sudo pacman -S --noconfirm hexyl hexedit

########################
######## CLEAN #########
########################

RUN sudo rm -r ${PATH_BUILD} * && \
    sudo pacman -Sc && \
    sudo rm -rf /tmp/*
WORKDIR ${PATH_ROOT}