#!/bin/bash
#
# Linux tool to kill ipython notebook server on a remote server and
# kill the current SSH tunnel for port forwarding
#
# Peter Frick, (modified from Anthony Ho), frickpl@stanford.edu


# Before you run this, you will have set the environmental variable $greendragon as user@greendragon.stanford.edu
# or replace $greendragon below as user@server.stanford.edu


if [ -z $1 ]
then
	echo "Description:"
	echo "Linux tool to stop ipython notebook server on a remote server"
	echo ""
	echo "Usage:"
	echo "This script can toggle between greenseq and greendragon"
	echo "To use greenseq, type any single word after the call, e.g.,       startIPythonNBServer.sh anyWord1"
	echo "To use gdragon, type any two words after the call, e.g.,          startIPythonNBServer.sh anyWord1 anyWord2"
	exit
elif [ $# -ge 2 ]
then
	echo '2+ inputs detected. Closing greendragon...'
	server=peter@greendragon.stanford.edu
elif [ $# -ge 1 ]
then	
	echo '1 input detected. Closing greenseq'
	server=peterfrick@greenseq.stanford.edu
fi


#server=peter@greendragon.stanford.edu
remote_port=8889
local_port=8888


# Kill the ipython notebook server on the remote server
ssh $server 'kill $(ps aux | grep -E "$USER.*[i]python.*--port=$remote_port" | awk '\''{print $2}'\'')'

# Kill the SSH tunnel for ipython notebook
kill $(ps aux | grep -E "$USER.*[s]sh -N -f -L localhost:$local_port:localhost:$remote_port" | awk '{print $2}')