#!/bin/bash
WSLOG=/tmp/ws-broadcast.log

touch $WSLOG
tail -n 0 -f $WSLOG --pid=$$ &
while read MSG; do echo $MSG >> $WSLOG; done
