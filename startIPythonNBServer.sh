#!/bin/bash
#
# Linux tool to start ipython notebook server on a remote server and 
# start a SSH tunnel for port forwarding
#
# Peter Frick, (modified from Anthony Ho), frickpl@stanford.edu


# Before you run this, you will have set the environmental variable $greendragon as user@greendragon.stanford.edu
# or replace $greendragon below as user@server.stanford.edu
# server=$greendragon
#server=peter@server.stanford.edu

if [ -z $1 ]
then
	echo "Description:"
	echo "Linux tool to start ipython notebook server on a remote server and"
	echo "start an SSH tunnel for port forwarding"
	echo ""
	echo "Usage:"
	echo "This script can toggle between greenseq and greendragon"
	echo "To use greenseq, type any single word after the call, e.g.,       startIPythonNBServer.sh anyWord1"
	echo "To use gdragon, type any two words after the call, e.g.,          startIPythonNBServer.sh anyWord1 anyWord2"
	exit
elif [ $# -ge 2 ]
then
	echo '2+ inputs detected. Opening greendragon...'
	server=peter@greendragon.stanford.edu
elif [ $# -ge 1 ]
then	
	echo '1 input detected. Opening greenseq'
	server=peterfrick@greenseq.stanford.edu
fi

#server=peter@greendragon.stanford.edu
remote_port=8889
local_port=8888


# Start ipython notebook server on remote server
ssh $server "nohup ipython notebook --pylab=inline --no-browser --port=$remote_port &> /dev/null < /dev/null &"

# Start SSH tunnel for port forwarding
ssh -N -f -L localhost:$local_port:localhost:$remote_port $server

#echo "Now connected to " $HOSTNAME


# Now you can access ipython notebook remotely via http://localhost:8888 on your favorite web browser
# This functionality is added after the script has been ran on the terminal prompt (type the script name)
