# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

umask 0022

# Local functions
function name() {
    printf '\033]0;%s\007' "$@";
}

function rpass() {
    n=$1
    [ -z "$n" ] && n="32"
    pass=`cat /dev/urandom | strings | grep -o '[[:alnum:]\/!@#$%^&*()<>,.,{}]' | head -n $n | tr -d '\n'`
    if which pbcopy > /dev/null; then
        echo -n "$pass" | pbcopy
    fi

    echo "$pass"
}

function rapass() {
    n=$1
    [ -z "$n" ] && n="32"
    pass=`cat /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n $n | tr -d '\n'`
    if which pbcopy > /dev/null; then
        echo -n "$pass" | pbcopy
    fi

    echo "$pass"
}

function update-dotfiles() {
    GIT_URL='https://github.com/ipartola/ipartola-bash-and-vim/tarball/master'

    p=`pwd`
    base=`mktemp -d /tmp/dotfilesXXXXXXXX`
    cd "$base"
    wget -q -O master.tar.gz $GIT_URL
    tar xzf master.tar.gz
    dirname=`tar tf master.tar.gz 2>/dev/null | head -n 1`

    for x in `ls -a $base/$dirname`; do
        [ $x == '.' ] && continue
        [ $x == '..' ] && continue
        [ $x == 'README' ] && continue
        echo installing $x
        cp -r $base/$dirname/$x ~/
    done

    cd $p
    rm -rf "$base"
    source ~/.bashrc
    if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
}

# Some aliases
alias vi='vim'
alias apt-get="sudo apt-get"
alias apt="sudo apt"
alias sysup="apt-get update && apt-get dist-upgrade && exit"
alias diff='diff -u'
alias sl='sl -e'
alias grep='grep --color=auto'
alias rehash='source ~/.bashrc'

# Preferred settings
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
HISTSIZE=100000
export EDITOR="vim"
export PATH="$HOME/.bin:$PATH:/sbin:/usr/sbin"
bind 'set match-hidden-files off'

# Include the local rc file
LOCAL_RC="$HOME/.bashrc_local"
test -f $LOCAL_RC && source $LOCAL_RC

# Initialization
name `whoami`@`hostname`
