#!/bin/sh -x

REMOTE_HOST=$1
UATH=${REMOTE_USER}@${REMOTE_HOST}

if [ -e ~/.ssh/id_rsa.pub ]
then
    echo "Key exist"
else
    echo "Key does not exist.Needs to be generated.Just click several enters."
    ssh-keygen
fi


SSH_BATCH="ssh -q -oBatchMode=yes -l ${REMOTE_USER}  ${REMOTE_HOST}"
#this script will set the environment on a remote machine
#it uses ssh to connect to the machine
#after the first password question it will copy the public key of the local to the remote machine
# from then on no password will be asked again
echo "Check ssh pubkey handsake."
#echo "If the password is not set, it will require twice.After that, no password will 
#ever be required from that machine"
ssh -oBatchMode=yes -l ${REMOTE_USER}  ${REMOTE_HOST} "exit"
#ssh -q ${UATH} exit
if [ $? -ne 0 ]
then
    PUBKEY=~/.ssh/id_rsa.pub
    cat ${PUBKEY}
    mkdir -p ~/.ssh
    echo "Copy pubkey to ~/.ssh/authorized_keys"
    cat ${PUBKEY} | ssh ${UATH} "mkdir -p ~/.ssh ; cat - >> ~/.ssh/authorized_keys"
else
    echo "No password needed!"
fi
