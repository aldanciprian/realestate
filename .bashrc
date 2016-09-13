# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200
TOKEN="mediu customizat de user"
test -s ~/.alias && . ~/.alias || true
# ignore duplicate commands, ignore commands starting with a space
export HISTCONTROL=erasedups:ignorespace

# keep the last 5000 entries
export HISTSIZE=9000

# append to the history instead of overwriting (good for multiple connections)
shopt -s histappend
HOST=`hostname`
export REMOTE_USER="pasarica"
if [ "${HOST}" =  "pasaricaw" ]
then
    echo "from windows"
    export ROOT="/drives/d/stuff/shared"
    export DIRG75="/drives/p"
    export DIRG68="/drives/r"
    export USER="${USERNAME}"
    #alias sync_main75="sync_prj.sh pasarica@gjdev75:/bldarea/pasarica/mainline_ctb ."
    alias sync_main75_apip="sync_prj.sh pasarica@gjdev75:/bldarea/pasarica/apip_main ."
	alias sync_main75_scrn="sync_prj.sh pasarica@gjdev75:/bldarea/pasarica/scrn_main ."
fi
if [ "${HOST}" =  "pasarical" ]
then
    echo "from linux"
    export ROOT="/media/sf_shared"
    export USERNAME="${USER}"
    export DIRG75="/media/gjdev75/pasarica"
    export DIRG68="/media/gjdev68/pasarica"
    alias sync_main75_apip="sync_prj.sh pasarica@gjdev75:/bldarea/pasarica/apip_main ."
	alias sync_main75_scrn="sync_prj.sh pasarica@gjdev75:/bldarea/pasarica/scrn_main ."
fi

if [ "${HOST}" =  "gjdev75" ] || [ "${HOST}" =  "gjdev68.spr" ]
then
    #echo "from gjdev75"
    export ROOT="/bldarea/${REMOTE_USER}/root_bld"
    export USERNAME="${USER}"
    export PATH="${ROOT}/installed/the_silver_searcher/bin:${PATH}"
    export PATH="${ROOT}/installed/eclipse:${PATH}"
    export PATH="${ROOT}/installed/htop/bin:${PATH}"
    export PATH="${ROOT}/installed/doxygen/bin:${PATH}"
    export PATH="${ROOT}/installed/cproto/bin:${PATH}"
    export PATH="${ROOT}/installed/2016/bin/x86_64-linux:${PATH}" # Tex installed manually
    export PATH="/bldarea/pasarica/sshpass/installed/bin:$PATH"
	alias view_testbench="/bldarea/anicolae/get_machine_info.sh"

	alias s2a="copy_diff_files_from_dir2dir.sh ../../scrn_main/console ."
	alias a2s="copy_diff_files_from_dir2dir.sh ../../apip_main/console ."

    export CDAPIP="${ROOT}/../apip_main"
    alias cdapip="cd ${CDAPIP}"
    export CDSCRN="${ROOT}/../scrn_main"
    alias cdscrn="cd ${CDSCRN}"
fi

# set other variables and aliases only if root is set 
if [ -n "${ROOT}" ]
then
    export HARDIP="172.27.126.93"
    export SSHPASS="kp4r1co"    
    export SCRIPTS="${ROOT}/scripts"
    export WORK="${ROOT}/scripts/work"
    export PATH="${SCRIPTS}:${PATH}"
    export PATH="${SCRIPTS}/work:${PATH}"
    #export PATH="/home/pasarica/.vim/bundle/YCM-Generator:${PATH}"
    export ENV="${ROOT}/env"

    alias s="source ~/.bashrc"
    alias l="ls -lahrt"
    alias ll="ls -allh"
    alias scripts="cd ${SCRIPTS}"
    alias work="cd ${WORK}"
    alias cdg75="cd ${DIRG75}"
    alias root="cd ${ROOT}"
    alias vibash="vi ~/.bashrc"
    alias vivim="vi ~/.vimrc"
    alias ff="find_file.sh"
    alias ag='ag --color-path "1;34" --color-line-number "0;31"'
    alias g75="ssh -X pasarica@gjdev75"
    alias g68="ssh -X pasarica@gjdev68"
    alias goto="sshpass -e ssh -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    alias g62="sshpass -e ssh -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@gjdev62"
    alias g25="sshpass -e ssh -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@gjdev25"
    alias g73="sshpass -e ssh -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@gjdev73"
    alias scpp="sshpass -e scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "
	alias set_r="set_remote.sh gjdev75; set_remote.sh gjdev68"

else
    echo "ROOT is not set !"
fi


grep_all_recursive() {
    grep -R "${1}" .
}
alias grepf=grep_all_recursive

shopt -s cdable_vars
shopt -s direxpand
