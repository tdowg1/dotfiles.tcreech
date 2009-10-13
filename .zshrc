
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
unsetopt BG_NICE                # do NOT nice bg commands
setopt CORRECT                  # command CORRECTION
setopt EXTENDED_HISTORY         # puts timestamps in the history
#setopt MENUCOMPLETE            # <-- lame.
setopt ALL_EXPORT
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning    
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -a zsh/mapfile mapfile
PATH="$HOME/bin:$HOME/myStuff/bin:$HOME/opt/bin:/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
TZ="America/New_York"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
EDITOR='vim'
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="[$PR_BLUE%n$PR_WHITE@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
RPS1="$PR_LIGHT_YELLOW(%D{%m-%d %H:%M})$PR_NO_COLOR"
#LANGUAGE=
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LC_CTYPE=C

if [ $SSH_TTY ]; then
  MUTT_EDITOR=vim
else
  MUTT_EDITOR=emacsclient.emacs-snapshot
fi

unsetopt ALL_EXPORT
# # --------------------------------------------------------------------
# # aliases
# # --------------------------------------------------------------------

alias slrn="slrn -n"
alias man='LC_ALL=C LANG=C man'
alias f=finger
alias ll='ls -l'

# Set up alias for ls for some color:
if [ `ls --color 2> /dev/null 1> /dev/null && echo true || echo false` = "true" ]; then
   # We are using GNU ls.
   alias ls='ls --color=auto '
else
   # Assuming we are using BSD ls.
   alias ls='ls -G '
fi

alias offlineimap-tty='offlineimap -u TTY.TTYUI'
alias hnb-partecs='hnb $HOME/partecs/partecs-hnb.xml'
alias rest2html-css='rst2html --embed-stylesheet --stylesheet-path=/usr/share/python-docutils/s5_html/themes/default/print.css'
alias vim='vim -X '
alias xtest='xlogo& ; sleep 1;killall xlogo'
#if [[ $HOSTNAME == "kamna" ]] {
#       alias emacs='emacs -l ~/.emacs.kamna'
#}

# alias =clear

#chpwd() {
#     [[ -t 1 ]] || return
#     case $TERM in
#     sun-cmd) print -Pn "\e]l%~\e\\"
#     ;;
#    *xterm*|screen|rxvt|(dt|k|E)term) print -Pn "\e]2;%~\a"
#    ;;
#    esac
#}
selfupdate(){
        URL="http://stuff.mit.edu/~jdong/misc/zshrc"
        echo "Updating zshrc from $URL..."
        echo "Press Ctrl+C within 5 seconds to abort..."
        sleep 5
        cp ~/.zshrc ~/.zshrc.old
        wget $URL -O ~/.zshrc
        echo "Done; existing .zshrc saved as .zshrc.old"
}
#chpwd

autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort
# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# Add some keybindings for ctrl-arrowkey movement with PuTTY
bindkey '\x1b\x4f\x43' forward-word # Ctrl + Right - advance 1 word
bindkey '\x1b\x4f\x44' backward-word # Ctrl + Left - go back 1 word
bindkey '\xff' backward-kill-word # Alt+Bksp - kill last word 
bindkey '\e[1~' beginning-of-line # Home - Move Beginning of Line
bindkey '\e[4~' end-of-line # End - Move Beginning of Line
bindkey '\e[3~' delete-char # Delete - Delete a char

# Get vi keybindings for line input
bindkey -v 

# Add the fancy anonymous script editor so that I can press 'v' in command
#  mode and get vim to edit the input.
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

alias ct='/opt/rational/clearcase/bin/cleartool '
# Directory in which to store shortcut dirs
#  (just a mess of symlinks.)
DIRDIR=$HOME/.dirs
# Function to add shortcut dirs
tmkdir(){
        mkdir -p $DIRDIR
        ln -s -f `pwd` $DIRDIR/$1
}

tcd(){
        if [[ $1 = "" ]]; then
            builtin cd;
        else
            if [[ -d $1 ]]; then
                builtin cd $1;
            else 
                # echo "step back: being magical..."
                builtin cd `readlink $DIRDIR/$1`
            fi
        fi
}

tls(){
        mkdir -p $DIRDIR
        ls $* $DIRDIR
}

trm(){
        rm $DIRDIR/$1
}

gfind(){
        for e in $*; do find . | grep $e;done | xargs
}

alias gf='gfind '

# Function to find/open files quickly for editing in vim
vimfind(){
        vim -p `gfind $*`
}

# On USR2, source a file. Used for global-export.
TRAPUSR2(){
   [ -f ~/.global_export_tmp ] && . ~/.global_export_tmp
}

# Export to /all/ instances of zsh that I can send USR2 to.
globalexport(){
   echo > ~/.global_export_tmp
   # This is done before anything goes into the file so that
   #   there is no chance of it being readable by other users.
   chmod 600 ~/.global_export_tmp
   echo "export $*" >> ~/.global_export_tmp
   killall -USR2 zsh
}

## Function to quickly grab the last SSH_AUTH_SOCK available on
##  a screen session entry and push it out to all of the user's
##  zsh instances. Note that this may not be desirable in all
##  cases, such as if you need multiple instances of ssh authentication
##  forwarding to exist simultaneously. In particular, if this account
##  is used by multiple users, then this can be pretty lame.
#globalgetauth(){
#   [ -f ~/.last_ssh_auth ] && globalexport `cat ~/.last_ssh_auth`
#}
#
## Get any legitimately set SSH_AUTH_SOCK in case .global_export_tmp
##  clobbers it below. Only grab it if we're a zsh instance outside
##  of screen.
#[ -z "$SCREEN_EXIST" ] && ORIGINAL_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
#
## On startup, catch up with at least the last gobal export if one exists.
## But only do this if we are inside screen.
#[ -n "$SCREEN_EXIST" ] && [ -f ~/.global_export_tmp ] && . ~/.global_export_tmp
#
## This must be the end of the file. Connects to or creates a screen session.
#if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
#   echo -n "Sup. Connecting to screen session (^C to skip) in 2" && \
#   sleep 0.25 && \
#   for i in {1..3}; do
#      echo -n "." && \
#      sleep 0.25 && \
#   done
#   echo -n "1" && \
#   sleep 0.25 && \
#   for i in {1..3}; do
#      echo -n "." && \
#      sleep 0.25 && \
#   done
#   ([ -n "$ORIGINAL_SSH_AUTH_SOCK" ] && echo > ~/.last_ssh_auth && chmod 600 ~/.last_ssh_auth && echo "SSH_AUTH_SOCK=$ORIGINAL_SSH_AUTH_SOCK" > ~/.last_ssh_auth || true ) && \
#   export SCREEN_EXIST=1 && \
#   screen -s zsh -DR && \
#   exit
#fi
#
