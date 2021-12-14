#!/bin/bash

#########################################################################
#
# SCRIPT: stt_auto_tasks.sh
# AUTHOR: Miguel Mora <info@salvatutiempo.com>
# DATE: 2021-12-14
# REV: 1.0
# PLATFORM: Not platform dependent
# PURPOSE: Run multiple tasks in massive hosts
# NOTES: 
#	- Need to replace "USERNAME" VARIABLE with your username for remote hosts
#	- Need to write in "hosts.txt" file IP addresses from destination hosts
#	- Need to write in "pass.txt" your password for remote hosts
#########################################################################

#########################################################################
# VARIABLES
#########################################################################

SSH="sshpass -e ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"
HOSTS="hosts.txt"
USER="USERNAME" # CHANGE TO CONNECTION USER 
SSHPASS=$(cat pass.txt) # NEED TO ADD REMOTE ACCESS PASSWORD IN THAT FILE
export SSHPASS

#########################################################################
# FUNCTIONS
#########################################################################

# pingable: Check if host is reachable
##############################################
pingable() {
	echo $(ping -c1 $1 | grep -c error)
}

# actions_remote: Run commands on remote hosts
##############################################
actions_remote() {
	echo "ESTOY DENTRO"
	HOSTNAME=$(hostname)
	IPS=$(hostname -I)
	DISTRI=$(hostnamectl | grep Operating | cut -d: -f2)
	CPUUSE=$( top -b -n 1 | grep Cpu | cut -d, -f 1 | cut -d: -f2)
	MEMFREE=$(free -b | grep ^Mem| tr -s " "| cut -d" " -f 4)
	ROOTFREE=$(df / --output=pcent | sed 1d)
	echo "${HOSTNAME},${IPS},${DISTRI},${CPUUSE},${MEMFREE},${ROOTFREE}"
}

#########################################################################
# MAIN
#########################################################################

for host in $(cat "$HOSTS")
do
	PINGABLE=$(pingable $host)
	if [ "$PINGABLE" == "0" ]
	then
		# For NON ROOT tasks
		$SSH "${USER}@${host}" "$(declare -f actions_remote); actions_remote"
		# For ROOT tasks (sudo tasks)
		# $SSH "${USER}@${host}" "echo '${SSHPASS}' | sudo --stdin bash -c '$(declare -f actions_remote); actions_remote'"
	else
		echo "HOST $host is UNREACHABLE"
	fi
done
