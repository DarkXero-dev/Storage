fastfetch

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to your emacs installation.
export PATH="$HOME/.config/emacs/bin:$PATH"

# Using Oh-My-Posh.
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/xero.omp.json)"

# Special Clear Message
alias clsm='clear && figlet -c -t -f small "Welcome to XeroLinux, ${USER:u}" | lolcat'
alias xff='clear && fastfetch --config ~/.config/fastfetch/stationxero.jsonc'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aliases archlinux branch github history zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-interactive-cd zsh-navigation-tools zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Path to bat config
export BAT_CONFIG_PATH="~/.config/bat/config.conf"

# LibAwaita Theme
export GTK_THEME=Layan-Dark

##Cmatrix thing
alias matrix='cmatrix -s -C magenta'

#iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l='eza -lah --color=always --group-directories-first --icons' # tree listing

#proxy/net
alias rnet="sudo systemctl restart NetworkManager"

#pacman unlock
alias unlock="sudo rm /var/lib/pacman/db.lck"

#available free memory
alias free="free -mt"

#continue download
alias wget="wget -c"

#readable output
alias df='df -h'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

#Replace nano with msedit
alias nano="msedit "
alias snano="sudo msedit "

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#Pacman for software managment
alias search='pacman -Ss '
alias remove='sudo pacman -Rcns '
alias pacin='sudo pacman -S'
alias linstall='sudo pacman -U *.pkg.tar.zst'
alias update='paru && fpup'
alias clrcache='sudo pacman -Scc'
alias orphans='[[ -n $(pacman -Qtdq) ]] && sudo pacman -Rns $(pacman -Qtdq)'
alias pup='sudo pacman -Syu'
alias plist='pacman -Ql '
alias pforeign='pacman -Qm'
alias pown='pacman -Qo '
alias pfiles='pacman -Fl '
alias pcheck='sudo pacman -Dk'
alias punused='pacman -Qtd'
alias psize="expac -H M '%m\t%n' | sort -h | tail -20"
alias pdiff='sudo pacdiff'
alias plog="tail -50 /var/log/pacman.log"
alias pinst="grep 'installed' /var/log/pacman.log | tail -20"
alias pupg="grep 'upgraded' /var/log/pacman.log | tail -20"
alias pexp='pacman -Qe'
alias pinfo='pacman -Qi '
alias pgrp='pacman -Qg '
alias pmirror='sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist'
alias fix-keys='sudo pacman-key --init && sudo pacman-key --populate'
alias cleanup='sudo pacman -Sc && sudo journalctl --vacuum-time=2weeks'

#Paru as aur helper - updates everything
alias pget='paru -S '
alias prm='paru -Rs '
alias psr='paru -Ss '
alias prem='paru -R '
alias yget='yay -S '
alias yrem='yay -R '

#Flatpak
alias fpup='flatpak update'
alias fls='flatpak list'
alias fup='flatpak update'
alias frm='flatpak uninstall '
alias fsearch='flatpak search '
alias fperm='flatpak info --show-permissions '

# Replace stuff with bat
alias cat='bat '
alias rg='batgrep '
alias tl='tldr '

#Snap Update
alias sup='sudo snap refresh'

#grub update
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'

#quickly kill stuff
alias kc='killall conky'

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

#Bash aliases
alias mkfile='touch'
alias thor='sudo thunar'
alias jctl='journalctl -p 3 -xb'
alias ssaver='xscreensaver-demo'
alias reload='source ~/.zshrc'
alias pingme='ping -c64 github.com'
alias cls='clear && fastfetch'
alias traceme='traceroute github.com'
alias jf='journalctl -f'
alias jerr='journalctl -p err -b'
alias pingg='ping -c 5 8.8.8.8'
alias h='history'
alias hg='history | grep '
alias hlast='history | tail -20'
alias e='$EDITOR '

#hardware info --short
alias hw="hwinfo --short"
alias temp='sensors'
alias wtf='dmesg | tail -20'
alias battery='upower -i $(upower -e | grep BAT) | grep percentage'

## HBlock
alias block="sudo hblock"
alias unhblock="hblock -S none -D none"

#Fixes & Tools
alias rshell='kquitapp6 plasmashell && kstart plasmashell'
alias rpower='sudo systemctl restart power-profiles-daemon'
alias reload-font='fc-cache -fv'
alias xdg-fix='xdg-user-dirs-update'

#youtube-dl
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias ytv-best='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" --merge-output-format mp4 '

#GiT  command
alias gcl='git clone '
alias gpl='git pull'
alias gst='git status'
alias gad='git add .'
alias gcm='git commit -m '
alias gps='git push'
alias glo='git log --oneline --graph'
alias gdf='git diff'
alias gbr='git branch'
alias gco='git checkout '
alias grst='git restore '
alias gstash='git stash'
alias gfetch='git fetch'
alias gmerge='git merge '
alias grebase='git rebase '
alias gtag='git tag'
alias gclean='git clean -fd'
alias gundo='git reset HEAD~1'
alias gwip='git commit -am "WIP"'
alias glast='git log -1 HEAD'
alias gremote='git remote -v'
alias gpull='git pull --rebase'

#Copy/Remove files/dirs
alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias mkdir='mkdir -pv'
alias rmd='rm -r'
alias srm='sudo rm'
alias srmd='sudo rm -r'
alias cpd='cp -R'
alias scpd='sudo cp -R'
alias duh='du -h --max-depth=1 | sort -h'
alias fhere='find . -name '
alias perms='stat -c "%a %n" '
alias own='stat -c "%U:%G %n" '
alias biggest='find . -type f -printf "%s %p\n" | sort -rn | head -20'
alias etree='eza --tree '
alias count='command ls -1 | wc -l'
alias mkscript='install -m 755 /dev/null '

#Disk / Storage
alias disk='df -h | grep -v tmpfs'
alias inode='df -i'
alias disks='lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE'
alias mnt='mount | column -t'

#Process Management
alias psa='ps auxf'
alias psg='ps aux | grep '
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'
alias kill9='kill -9 '
alias killall9='killall -9 '

#nano
alias bashrc='nano ~/.bashrc'
alias zshrc='nano ~/.zshrc'
alias pconf='sudo nano /etc/pacman.conf'
alias mkpkg='sudo nano /etc/makepkg.conf'
alias ngrub='sudo nano /etc/default/grub'
alias smbconf='sudo nano /etc/samba/smb.conf'
alias nmirrorlist='sudo nano /etc/pacman.d/mirrorlist'

#cd/ aliases
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bk='cd -'
alias music='cd ~/Music'
alias vids='cd ~/Videos'
alias conf='cd ~/.config'
alias desk='cd ~/Desktop'
alias pics='cd ~/Pictures'
alias dldz='cd ~/Downloads'
alias docs='cd ~/Documents'
alias sapps='cd /usr/share/applications'
alias lapps='cd ~/.local/share/applications'

#verify signature for isos
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'

#receive the key of a developer
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

##Refresh Keys
alias rkeys='sudo pacman-key --refresh-keys'

#Package Info
alias info='sudo pacman -Si '
alias infox='sudo pacman -Sii '

## Build AUR Packages
alias xdx='updpkgsums && makepkg -r -s --noconfirm'
alias xddx='makepkg -g >> PKGBUILD && makepkg -r -s --noconfirm'

## Ventoy Web
alias vweb='cd /opt/ventoy/ && sudo sh VentoyPlugson.sh -H 127.0.0.1 /dev/sdd'

#shutdown or reboot
alias sr="sudo reboot"
alias ssn="sudo shutdown now"
alias su='sudo -i'

#System Info
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'
alias week='date +%V'
alias cal3='cal -3'
alias utc='date -u'
alias tz='timedatectl'
alias myip='curl ifconfig.me'
alias localip="ip a | grep 'inet ' | awk '{print \$2}'"
alias ports='ss -tulanp'
alias meminfo='command free -h'
alias cpuinfo='lscpu'
alias bc='bc -l'

#SystemD
alias se='sudo systemctl enable '
alias sd='sudo systemctl disable '
alias sstart='sudo systemctl start '
alias sq='sudo systemctl stop '
alias srs='sudo systemctl restart '
alias sstatus='sudo systemctl status '
alias sdr='sudo systemctl daemon-reload'
alias uctl='systemctl --user '
alias sctl='sudo systemctl'
alias watch='watch -n 1 '
alias jsize='journalctl --disk-usage'
alias failed='systemctl --failed'
alias boot-log='journalctl -b'
alias kern-log='journalctl -k'
alias lastboot='last reboot | head -5'
alias uptime2='uptime -p'
alias klog='journalctl --user -u plasma-plasmashell -f'

#Networking
alias dns='cat /etc/resolv.conf'
alias pubkey='cat ~/.ssh/id_ed25519.pub'
alias ip='ip --color=auto'
alias tracert='traceroute '
alias ufw-status='sudo ufw status verbose'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wifi='nmcli dev wifi'
alias wifion='nmcli radio wifi on'
alias wifioff='nmcli radio wifi off'
alias connections='ss -tp'
alias open-ports='ss -tuln'
alias dmesg='dmesg --color=always | less -R'
alias grep-ip="grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"

#SSH
alias sshkey='ssh-keygen -t ed25519 -C '
alias sshcp='ssh-copy-id '
alias known='nano ~/.ssh/known_hosts'
alias sshconf='nano ~/.ssh/config'

#Clipboard
alias copy='wl-copy'
alias paste='wl-paste'

#Archives
alias mktar='tar -czf '
alias untar='tar -xzf '
alias mkzip='zip -r '
alias lstar='tar -tzf '

#Text / Search
alias gg='grep -r '
alias gi='grep -ri '
alias wcl='wc -l'
alias hd='hexdump -C '

#Python / Dev
alias py='python3 '
alias pip='pip3 '
alias venv='python3 -m venv '
alias serve='python3 -m http.server 8080'
alias json='python3 -m json.tool'

#Permissions
alias chx='chmod +x '
alias c755='chmod 755 '
alias c644='chmod 644 '
alias c700='chmod 700 '
alias own-me='sudo chown $USER:$USER '
alias perm-fix='sudo chmod -R u+rw '

#Cleanup
alias cleantmp='sudo rm -rf /tmp/*'
alias cleantrash='rm -rf ~/.local/share/Trash/*'
alias clcache='rm -rf ~/.cache/*'
alias nohist='unset HISTFILE'

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Shell-GPT integration ZSH v0.1
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd")
    zle end-of-line
fi
}
zle -N _sgpt_zsh
# Shell-GPT integration ZSH v0.1
