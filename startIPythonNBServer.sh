#!/bin/bash
#
# Linux tool to start ipython notebook server on a remote server and 
# start a SSH tunnel for port forwarding
#
# Anthony Ho, ahho@stanford.edu, 2/20/2015
# Last update 2/20/2015


# Before you run this, you will have set the environmental variable $greendragon as user@greendragon.stanford.edu
# or replace $greendragon below as user@server.stanford.edu
# server=$greendragon
#server=peter@server.stanford.edu
server=peter@greendragon.stanford.edu
remote_port=8889
local_port=8888


# Start ipython notebook server on remote server
ssh $server "nohup ipython notebook --pylab=inline --no-browser --port=$remote_port &> /dev/null < /dev/null &"

# Start SSH tunnel for port forwarding
ssh -N -f -L localhost:$local_port:localhost:$remote_port $server

# Now you can access ipython notebook remotely via http://localhost:8888 on your favorite web browser
# This functionality is added after the script has been ran on the terminal prompt (type the script name)
