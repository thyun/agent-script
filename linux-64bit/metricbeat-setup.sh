#!/bin/bash

# Source function library.
. /etc/init.d/functions

DOWNLOAD_BASE_HOME=http://downloads.jmsight.com
DOWNLOAD_BASE_NAME=metricbeat-6.7.2-linux-x86_64
DOWNLOAD_BASE_FILE=${DOWNLOAD_BASE_NAME}.tar.gz
DOWNLOAD_BASE_URL=${DOWNLOAD_BASE_HOME}/downloads/$DOWNLOAD_BASE_FILE
DOWNLOAD_EXT_HOME=http://downloads.jmsight.com
DOWNLOAD_EXT_FILE=metricbeat-ext.tar.gz
DOWNLOAD_EXT_URL=${DOWNLOAD_EXT_HOME}/downloads/$DOWNLOAD_EXT_FILE

SCRIPT="$0"
SETUP_HOME=`dirname "$SCRIPT"`
SETUP_HOME=`cd "$SETUP_HOME"; pwd`
cd $SETUP_HOME
PROGRAM_NAME=metricbeat
PROGRAM_HOME=$SETUP_HOME/${PROGRAM_NAME}
PROGRAM_SCRIPT=${PROGRAM_NAME}.sh
PROGRAM_YML=${PROGRAM_NAME}.yml

JMSIGHT_ID=Unknown

install () {
    echo -n "Installing $PROGRAM: "
	if [ -d "$PROGRAM_HOME" ]; then
        echo "Previously installed directory exists, moving"
		$PROGRAM_HOME/$PROGRAM_SCRIPT stop
		mv $PROGRAM_NAME $PROGRAM_NAME-`date +%Y%m%d-%H%M%S`
    fi

	curl $DOWNLOAD_BASE_URL --output $DOWNLOAD_BASE_FILE
	tar xvfpz $DOWNLOAD_BASE_FILE
    mv $DOWNLOAD_BASE_NAME $PROGRAM_NAME
	curl $DOWNLOAD_EXT_URL --output $DOWNLOAD_EXT_FILE
	tar xvfpz $DOWNLOAD_EXT_FILE

    sed -i "s/%\[jmsightId\]/$JMSIGHT_ID/" ${PROGRAM_HOME}/${PROGRAM_YML}
	$PROGRAM_HOME/$PROGRAM_SCRIPT start
}

upgrade () {
    echo "Upgrade not implemented"
}

usage() {
    echo $"Usage: $0 install {jmsightId}}"
    echo $"ex) metricbeat-setup.sh install JMSIGHT-DEV-190523175500"
}

# Start program
if [ -z $1 ];then
    CMD=`basename $0 | awk -F- '{print $1}'`
else
    CMD=$1
fi

case "$CMD" in
    install)
        if [ $# -ne 2 ]; then
            usage
            exit 1
        fi
        JMSIGHT_ID=$2
        install
        ;;
    upgrade)
        upgrade
        ;;
  *)
        usage
        exit 1
esac

exit $?

