#!/bin/sh -x

if [ -n "$1"  ]
then
    :
else
   echo "which remote ?"
   exit -1
fi


REMOTE_HOST=$1
UATH=${REMOTE_USER}@${REMOTE_HOST}
SSH_BATCH="ssh -q -oBatchMode=yes -l ${REMOTE_USER}  ${REMOTE_HOST}"
#secure remote so no password is needed anymore
secure_remote.sh ${REMOTE_HOST} 



$SSH_BATCH "rm -rf /bldarea/${REMOTE_USER}/root_bld ; rm -f ~/.bashrc ; rm -f ~/.vimrc ; rm -f ~/.cscope_maps.vim ; rm -rf .vim"


$SSH_BATCH "test -e ~/.bashrc_initial"
if [ $? -ne 0 ]
then
    :
else
    $SSH_BATCH "grep 'mediu customizat de user' ~/.bashrc_initial"
      if [ $? -ne 0 ] 
      then 
          $SSH_BATCH "cp -f ~/.bashrc_initial ~/.bashrc"
      else
          $SSH_BATCH "rm -rf ~/.bashrc_initial"
      fi
fi

$SSH_BATCH "test -e ~/.vimrc_initial"
if [ $? -ne 0 ]
then
    :
else
    $SSH_BATCH "grep 'mediu customizat de user' ~/.vimrc_initial"
      if [ $? -ne 0 ] 
      then 
          $SSH_BATCH "cp -f ~/.vimrc_initial ~/.vimrc"
      else
          $SSH_BATCH "rm -rf ~/.vimrc_initial"
      fi
fi

$SSH_BATCH "test -e ~/.vim_initial"
if [ $? -ne 0 ]
then
    :
else
    $SSH_BATCH "ls -all ~/.vim/ | grep 'mediu_customizat_de_user'"
      if [ $? -ne 0 ] 
      then 
          $SSH_BATCH "cp -Rf  ~/.vim_initial ~/.vim"
      else
          $SSH_BATCH "rm -rf ~/.vim_initial"
      fi
fi


#final step create the environment_created file in home folder
$SSH_BATCH "rm -f ~/environment_created"
$SSH_BATCH "rm -f ~/remote_script.sh"

exit 0
