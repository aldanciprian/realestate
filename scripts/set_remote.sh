#!/bin/sh +x

if [ -n "$1"  ]
then
    REMOTE_HOST=$1
else
   echo "which remote ?"
   exit -1
fi

if [ "${REMOTE_HOST}" == "gjdev68" ]
then
    ECLIPSE_TGZ="eclipse-cpp-juno-SR2-linux-gtk-x86_64.tar.gz"
    DOXY_FOLDER="doxygen-1.8.9.1"
    DOXYGEN_TGZ="doxygen-1.8.9.1.src.tar.gz"
else
    ECLIPSE_TGZ="eclipse-cpp-neon-R-linux-gtk-x86_64.tar.gz"
    DOXY_FOLDER="doxygen-1.8.11"
    DOXYGEN_TGZ="doxygen-1.8.11.src.tar.gz"
fi

echo "eclipse "$ECLIPSE_TGZ
echo "doxygen "$DOXYGEN_TGZ


UATH=${REMOTE_USER}@${REMOTE_HOST}
SSH_BATCH="ssh -q -oBatchMode=yes -l ${REMOTE_USER}  ${REMOTE_HOST}"
#secure remote so no password is needed anymore
secure_remote.sh ${REMOTE_HOST} 


$SSH_BATCH "test -e ~/.bashrc_initial"
if [ $? -ne 0 ]
then
    echo "initial does not  exist"
    $SSH_BATCH "cp ~/.bashrc ~/.bashrc_initial"
fi

$SSH_BATCH "test -e ~/.vimrc_initial"
if [ $? -ne 0 ]
then
    echo "initial does not  exist"
    $SSH_BATCH "cp ~/.vimrc ~/.vimrc_initial"
fi

$SSH_BATCH "test -e ~/.vim_initial"
if [ $? -ne 0 ]
then
    echo "initial does not  exist"
    if [ ! -L ~/.vim ]
    then
        # .vim folder is not a symbolic link
        $SSH_BATCH "cp -R ~/.vim ~/.vim_initial"
    fi
fi

$SSH_BATCH "test -e environment_created"
if [ $? -ne 0 ]
then
	echo "Refresh"
else
	echo "The environment is allready created"
	echo "Delete the file ~/environment_created in order to do a refresh"
	#exit 0
fi

$SSH_BATCH "mkdir -p /bldarea/${REMOTE_USER}/root_bld"
$SSH_BATCH "mkdir -p /bldarea/${REMOTE_USER}/root_bld/env"
$SSH_BATCH "mkdir -p /bldarea/${REMOTE_USER}/root_bld/installed"
$SSH_BATCH "mkdir -p /bldarea/${REMOTE_USER}/root_bld/kits"	
$SSH_BATCH "mkdir -p /bldarea/${REMOTE_USER}/root_bld/scripts"	

scp $ENV/.bashrc ${REMOTE_USER}@${REMOTE_HOST}:/bldarea/${REMOTE_USER}/root_bld/env

#copy env folder on remote
rsync -v -u  -r ${ENV} ${REMOTE_USER}@${REMOTE_HOST}:/bldarea/${REMOTE_USER}/root_bld/
$SSH_BATCH "ln -sf /bldarea/${REMOTE_USER}/root_bld/env/.vimrc ~/.vimrc ; ln -sf /bldarea/${REMOTE_USER}/root_bld/env/.bashrc ~/.bashrc ; [ ! -L  ~/.vim ] && ln -sf /bldarea/${REMOTE_USER}/root_bld/env/.vim  ~/.vim ; ln -sf /bldarea/${REMOTE_USER}/root_bld/env/.cscope_maps.vim ~/.cscope_maps.vim"


#copy scripts folder on remote
rsync -v -u  -r ${SCRIPTS}  ${REMOTE_USER}@${REMOTE_HOST}:/bldarea/${REMOTE_USER}/root_bld/ 



#cat <<EOF > /tmp/remote_script.sh

##if [ !  -d "/bldarea/${REMOTE_USER}/root_bld/installed/the_silver_searcher" ]
##then
    ###this might need to be executed from interactive shell
    ##git clone https://github.com/ggreer/the_silver_searcher /bldarea/${REMOTE_USER}/root_bld/kits/the_silver_searcher
    ##cd /bldarea/${REMOTE_USER}/root_bld/kits/the_silver_searcher && ./build.sh --prefix=/bldarea/${REMOTE_USER}/root_bld/installed/the_silver_searcher ; make ; make install 
    
##fi

##if [ !  -d "/bldarea/${REMOTE_USER}/root_bld/installed/htop" ]
##then
    ###this might need to be executed from interactive shell
    ##git clone https://github.com/hishamhm/htop /bldarea/${REMOTE_USER}/root_bld/kits/htop
    ##cd /bldarea/${REMOTE_USER}/root_bld/kits/htop && ./autogen.sh && ./configure --prefix=/bldarea/${REMOTE_USER}/root_bld/installed/htop ; make ; make install 
    
##fi
#EOF

#scp /tmp/remote_script.sh ${UATH}:/home/${REMOTE_USER}
#${SSH_BATCH} 'sh ~/remote_script.sh'




#install tools
# ag
$SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/installed/the_silver_searcher"
if [ $? -ne 0 ]
then
    echo "install the silver searcher (ag)"
    $SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/env/tools/the_silver_searcher"
    if [ $? -ne 0 ]
    then
    scp -R ${ENV}/tools/the_silver_searcher ${UATH}:/bldarea/${REMOTE_USER}/root_bld/env/tools/ 
    fi
 
    $SSH_BATCH "cd  /bldarea/${REMOTE_USER}/root_bld/env/tools/the_silver_searcher ; ./build.sh --prefix=/bldarea/${REMOTE_USER}/root_bld/installed/the_silver_searcher ; make ; make install "
fi

#htop
$SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/installed/htop"
if [ $? -ne 0 ]
then
    echo "install htop " 
    $SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/env/tools/htop"
    if [ $? -ne 0 ]
    then
    scp -R ${ENV}/tools/htop ${UATH}:/bldarea/${REMOTE_USER}/root_bld/env/tools/ 
    fi
 
    $SSH_BATCH "cd  /bldarea/${REMOTE_USER}/root_bld/env/tools/htop ; ./autogen.sh && ./configure --prefix=/bldarea/${REMOTE_USER}/root_bld/installed/htop ; make ; make install "
fi
#eclipse
$SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/installed/eclipse"
if [ $? -ne 0 ]
then
    echo "install eclipse"
    $SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/env/tools/${ECLIPSE_TGZ}"
    if [ $? -ne 0 ]
    then
    scp ${ENV}/tools/${ECLIPSE_TGZ} ${UATH}:/bldarea/${REMOTE_USER}/root_bld/env/tools/ 
    fi

    $SSH_BATCH "cp /bldarea/${REMOTE_USER}/root_bld/env/tools/${ECLIPSE_TGZ} /bldarea/${REMOTE_USER}/root_bld/installed/ ; cd /bldarea/${REMOTE_USER}/root_bld/installed ; tar -zxvf ${ECLIPSE_TGZ} ; cd eclipse ; mkdir -p workspace"
fi

#doxygen
$SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/installed/doxygen"
if [ $? -ne 0 ]
then
    echo "install doxygen"
    $SSH_BATCH "test -e /bldarea/${REMOTE_USER}/root_bld/env/tools/${DOXYGEN_TGZ}"
    if [ $? -ne 0 ]
    then
    scp ${ENV}/tools/${DOXYGEN_TGZ} ${UATH}:/bldarea/${REMOTE_USER}/root_bld/env/tools/ 
    fi
    if [ ${DOXYGEN_TGZ}  == 'doxygen-1.8.11.src.tar.gz'  ]
    then
        echo "doxy $DOXY_FOLDER"
        $SSH_BATCH "cp /bldarea/${REMOTE_USER}/root_bld/env/tools/${DOXYGEN_TGZ} /bldarea/${REMOTE_USER}/root_bld/installed/ ; cd /bldarea/${REMOTE_USER}/root_bld/installed ; tar -zxvf ${DOXYGEN_TGZ} ; cd $DOXY_FOLDER ; mkdir -p /bldarea/${REMOTE_USER}/root_bld/installed/doxygen ; cd /bldarea/${REMOTE_USER}/root_bld/installed/doxygen ;  cmake -G \"Unix Makefiles\" /bldarea/${REMOTE_USER}/root_bld/installed/$DOXY_FOLDER/ ; make  "
    else
        echo "doxy $DOXY_FOLDER"
        $SSH_BATCH " cp /bldarea/${REMOTE_USER}/root_bld/env/tools/${DOXYGEN_TGZ} /bldarea/${REMOTE_USER}/root_bld/installed/ ; cd /bldarea/${REMOTE_USER}/root_bld/installed ; tar -zxvf ${DOXYGEN_TGZ} ; cd $DOXY_FOLDER  ; mkdir -p /bldarea/${REMOTE_USER}/root_bld/installed/doxygen ; pwd ; ./configure --prefix=/bldarea/${REMOTE_USER}/root_bld/installed/doxygen ; make ; make install "
    fi
fi

#set rwx for remote_user
$SSH_BATCH "chmod -R u+rwx /bldarea/${REMOTE_USER}/root_bld/"

#final step create the environment_created file in home folder
$SSH_BATCH "touch environment_created"

exit 0
