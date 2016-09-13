#!/bin/sh

if [ ! -n "${1}" ]
then
	echo "Which machine ?"
	exit -1
fi

GOTO="sshpass -e ssh -X -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

${GOTO} root@${1} 'pcuBye ; pm_edit set PMP_CGC_startFlex 0 ; pm_edit set PMP_SS_startXWindows 0 ; pm_edit set PMP_SS_startWindowManager 0 ; pm_edit set  PMP_SS_shutdownOnExit 0 ; pm_edit set PMP_SS_powerOffOnShutdown 0 ; pm_edit set PMP_CGC_startHtml 0' 
