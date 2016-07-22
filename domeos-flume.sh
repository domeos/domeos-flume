#!/bin/sh

source_str="a1.sources = "
sink_str="a1.sinks = "
channel_str="a1.channels = "

echo "DOMEOS_FLUME_LOG_COUNT=${DOMEOS_FLUME_LOG_COUNT}, DOMEOS_FLUME_CHANNEL_DIR=${DOMEOS_FLUME_CHANNEL_DIR}"
for i in $(seq 1 ${DOMEOS_FLUME_LOG_COUNT}); do
	source_str="${source_str}"" r${i} "
	sink_str="${sink_str}"" k${i} "
	channel_str="${channel_str}"" c${i} "
done

echo "
${source_str}
${sink_str}
${channel_str}
" > flume.properties

if [ -z $DOMEOS_FLUME_CHANNEL_DIR ]; then
	DOMEOS_FLUME_CHANNEL_DIR=.
fi
for INDEX in $(seq 1 $DOMEOS_FLUME_LOG_COUNT); do
	LOGFILE=`eval "echo $""DOMEOS_FLUME_LOGFILE""${INDEX}"`
	MORECMD=`eval "echo $""DOMEOS_FLUME_MORECMD""${INDEX}"`
	TOPIC=`eval "echo $""DOMEOS_FLUME_TOPIC""${INDEX}"`
	if [ -z $DOMEOS_FLUME_BROKER ]; then
		echo "warning!!! DOMEOS_FLUME_BROKER not set!!"
	fi
	if [ -z $LOGFILE ]; then
		echo "warning!!! DOMEOS_FLUME_LOGFILE${INDEX} not set!!"
	fi
	if [ -z $TOPIC ]; then
		echo "warning!!! DOMEOS_FLUME_TOPIC${INDEX} not set!!"
	fi
	echo "a1.sources.r${INDEX}.type = exec
a1.sources.r${INDEX}.shell = /bin/bash -c
a1.sources.r${INDEX}.command = tail -F $LOGFILE $MORECMD
a1.sources.r${INDEX}.channels = c$INDEX
a1.sinks.k${INDEX}.type = org.apache.flume.sink.kafka.KafkaSink
a1.sinks.k${INDEX}.topic = $TOPIC
a1.sinks.k${INDEX}.brokerList = ${DOMEOS_FLUME_BROKER}
a1.sinks.k${INDEX}.requiredAcks = 1
a1.sinks.k${INDEX}.batchSize = 20
a1.sinks.k${INDEX}.channel = c$INDEX
a1.channels.c${INDEX}.type = SPILLABLEMEMORY
a1.channels.c${INDEX}.memoryCapacity = 10000
a1.channels.c${INDEX}.overflowCapacity = 100000000
a1.channels.c${INDEX}.byteCapacity = 10000000000
a1.channels.c${INDEX}.checkpointDir = ${DOMEOS_FLUME_CHANNEL_DIR}/flume_checkpoint${INDEX}
a1.channels.c${INDEX}.dataDirs = ${DOMEOS_FLUME_CHANNEL_DIR}/flume_data
" >> flume.properties
done
