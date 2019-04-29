#!/bin/bash

# Source function library.
. /etc/init.d/functions

DOWNLOAD_HOME=http://192.168.124.131:8080
DOWNLOAD_FILE=metricbeat.tar.gz
DOWNLOAD_EXT=metricbeat-ext.tar.gz

SCRIPT="$0"
SETUP_HOME=`dirname "$SCRIPT"`
SETUP_HOME=`cd "$SETUP_HOME"; pwd`
cd $SETUP_HOME
PROGRAM=metricbeat
PROGRAM_HOME=$SETUP_HOME/metricbeat
PROGRAM_SCRIPT=metricbeat.sh

install () {
    echo -n "Installing $PROGRAM: "
	if [ -d "$PROGRAM_HOME" ]; then
        echo "Previously installed directory exists, moving"
		$PROGRAM_HOME/$PROGRAM_SCRIPT stop
		mv $PROGRAM $PROGRAM-`date +%Y%m%d-%H%M%S`
    fi

	curl  ${DOWNLOAD_HOME}/downloads/$DOWNLOAD_FILE --output $DOWNLOAD_FILE
	tar xvfpz $DOWNLOAD_FILE
	curl  ${DOWNLOAD_HOME}/downloads/$DOWNLOAD_EXT --output $DOWNLOAD_EXT
	tar xvfpz $DOWNLOAD_EXT
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

