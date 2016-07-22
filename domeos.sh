#!/bin/sh
# three situation:
#   1. CLEAN           only need to delete unused expired log periodically
#   2. COLLECT         only need to collect log and send to kafka
#   3. CLEAN_COLLECT   both need to delete unused expired log and collect log

# step 1. generate proper config file and shell script
## if need to delete log periodically 
if [ ! -z $DOMEOS_CLEAN_LOG_COUNT ]; then
    sh domeos-cleanlog.sh
    operation="CLEAN"
    #nohup sh clean_log.sh &
    ## if need to collect log too
    if [ ! -z $DOMEOS_FLUME_LOG_COUNT ]; then 
        sh domeos-flume.sh
        operation="CLEAN_COLLECT"
    fi
else
    ## only need to collect log
    sh domeos-flume.sh
    operation="COLLECT"
fi

# step 2. run 
echo "operation=$operation" >> /opt/a.log
case $operation in
    (CLEAN)
        sh clean_log.sh
        ;;
    (COLLECT)
        /opt/apache-flume-1.6.0-bin/bin/flume-ng agent -f /opt/apache-flume-1.6.0-bin/flume.properties -c /opt/apache-flume-1.6.0-bin/conf -n a1 -Dflume.root.logger=INFO,console
        ;;
    (CLEAN_COLLECT)
        sh clean_log.sh >/dev/null 2>&1 &
        /opt/apache-flume-1.6.0-bin/bin/flume-ng agent -f /opt/apache-flume-1.6.0-bin/flume.properties -c /opt/apache-flume-1.6.0-bin/conf -n a1 -Dflume.root.logger=INFO,console
        ;;
    (*)
        echo "wrong operation=$operation, should never happen"
        ;;
esac
