#!/bin/bash

# Source function library.
. /etc/init.d/functions

SCRIPT="$0"
PROGRAM=metricbeat
METRICBEAT_HOME=`dirname "$SCRIPT"`
METRICBEAT_HOME=`cd "$METRICBEAT_HOME"; pwd`
METRICBEAT_PIDDIR=$METRICBEAT_HOME
METRICBEAT_PID="$METRICBEAT_PIDDIR/${PROGRAM}.pid"
cd $METRICBEAT_HOME

check_status() {
    PID=`pidofproc $PROGRAM`
    if [ $? -eq 0 ];then
        echo "$PROGRAM (pid ${PID}) is running..."
        return 0
    else
        echo "$PROGRAM is stopped"
        return 9
    fi
}

start () {
	if [ -f $COLLECTDMONPID ];then
#       status -p $COLLECTDMONPID $prog 
        check_status
        [ $? -eq 0 ] && return 1
   	fi

    echo -n $"Starting $PROGRAM: "
    daemon "$METRICBEAT_HOME/$PROGRAM -e -c metricbeat.yml >& /dev/null &"
	RETVAL=$?; echo
    PID=`pidofproc $PROGRAM`
	echo $PID > $METRICBEAT_PID
    [ $RETVAL -eq 0 ]
}

stop () {
    echo -n $"Stopping $PROGRAM: "
    killproc -p $METRICBEAT_PID $PROGRAM
    RETVAL=$?
    echo ""
    [ $RETVAL -eq 0 ]
#        [ $RETVAL -eq 0 ] && rm -f ${METRICAGENT_PIDDIR}/${service}.lock
}

# Start program
if [ -z $1 ];then
    CMD=`basename $0 | awk -F- '{print $1}'`
else
    CMD=$1
fi

case "$CMD" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        check_status
        ;;
    restart|reload)
#        check_config
#        rc="$?"
        stop
        start
        ;;
  *)
        echo $"Usage: $0 {start|stop|status|restart|reload}"
        exit 1
esac

exit $?

