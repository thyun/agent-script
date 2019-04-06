#!/bin/bash

# Source function library.
. /etc/init.d/functions

SCRIPT="$0"
SETUP_HOME=`dirname "$SCRIPT"`
SETUP_HOME=`cd "$SETUP_HOME"; pwd`
cd $SETUP_HOME
PROGRAM=metricbeat
PROGRAM_HOME=$SETUP_HOME/metricbeat
PROGRAM_SCRIPT=metricbeat.sh
DOWNLOAD_FILE=metricbeat.tar.gz

install () {
    echo -n "Installing $PROGRAM: "
	curl localhost/$DOWNLOAD_FILE --output $DOWNLOAD_FILE
	tar xvfpz $DOWNLOAD_FILE
	$PROGRAM_HOME/$PROGRAM_SCRIPT start
}

upgrade () {
    echo "Upgrade not implemented"
}

# Start program
if [ -z $1 ];then
    CMD=`basename $0 | awk -F- '{print $1}'`
else
    CMD=$1
fi

case "$CMD" in
    install)
        install
        ;;
    upgrade)
        upgrade
        ;;
  *)
        echo $"Usage: $0 {install|upgrade}"
        exit 1
esac

exit $?

