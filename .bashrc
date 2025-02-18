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
#force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

export daospath=/root/project/stor/daos
export CPATH=${daospath}/install/include/:$CPATH
export PATH=${daospath}/install/bin/:${daospath}/install/sbin:$PATH
export PATH=/root/project/stor/daos/install/bin:$PATH:/usr/local/go/bin:/root/project/stor/daos/build/external/debug/ofi/build/fabtests/bin:/root/project/hpc/mpi/ompi/openmpi-install/bin:/root/project/stor/daos/install/prereq/debug/ofi/bin
export GO_BIN=/usr/local/go/bin
#export GOROOT=/usr/local/go

# MPICH ENV
PREFIX=/root/project/hpc/mpi/daos/mpich-3.4.3/install
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export INCLUDE="$PREFIX/include:$INCLUDE"

ssh_copy_id(){
	for ip in s117 s118;do ssh-copy-id root@$ip;done
}

ips2='s117 s118 s119'
run_cmd_no_master(){
	local command=$*
	if [[ $* == "" ]]; then
		echo "$1 pls give cmd"
	else
		for ip in $ips2; do
			echo -e  "\n\033[32m`date +'%Y/%m/%d %H:%M:%S'` $ip $*\033[0m"
		        if [[ $ip == 's117' ]];then
			        echo -e  "skip master(s117)"
			else
				ssh $ip "${command}"
		        fi
		done
	fi
}

function run_cmd(){
	local command=$*
	if [[ $* == "" ]]; then
	  echo "$1 pls give cmd"
	else
		for ip in $ips2; do
			echo -e  "\n\033[32m`date +'%Y/%m/%d %H:%M:%S'` $ip $*\033[0m"
      if [[ $ip == 's117' ]];then
        eval ${command}
			else
			  ssh $ip "${command}"
      fi
		done
	fi
}

mpi_root(){
	cd /root/project/hpc/mpi/openmpi-5.0.6/
}

ompi_info_run(){
	/root/project/hpc/mpi/openmpi-5.0.6/build/ompi/tools/ompi_info/ompi_info
}

get_mlx_nic(){
  run_cmd "lspci |grep -i mellanox"
}

ibdev(){
	run_cmd "lspci |grep -i mellanox;ibdev2netdev;ibv_devices;ibv_devinfo;ibstat"
}

openibd_status(){
	run_cmd "/etc/init.d/openibd status"
}

gids(){
	run_cmd "show_gids"
}

perftest_root(){
	cd /root/project/rdma/perftest
}

daos_root(){
	cd /root/project/stor/daos
}

daos_ranks(){
	dmg sys query -v
}

daos_destory(){
	run_cmd "pkill daos_agent;pkill daos_server;umount /mnt/daos/1"
}

daos_stop(){
        pkill daos_agent
        pkill daos_server

}

daos_start(){
	mkdir -p /var/run/daos_server
	mkdir -p /var/run/daos_agent
	daos_agent &
	daos_server start &
}

daos_restart() {
	daos_stop
	daos_start
}

