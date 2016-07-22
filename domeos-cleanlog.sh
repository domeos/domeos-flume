#!/bin/sh

# expiretime unit is minutes

echo "
#!/bin/sh

clean_log () {" > clean_log.sh

for INDEX in $(seq 1 $DOMEOS_CLEAN_LOG_COUNT); do
    LOGFILE=`eval "echo $""DOMEOS_CLEAN_LOGFILE""${INDEX}"`    
    EXPIRETIME=`eval "echo $""DOMEOS_CLEAN_EXPIRETIME""${INDEX}"`
    if [ -z $LOGFILE ]; then
        echo "warning!!! DOMEOS_CLEAN_LOGFILE${INDEX} not set!!"
    fi
    if [ -z $EXPIRETIME ]; then
        echo "warning!!! DOMEOS_CLEAN_EXPIRETIME${INDEX} not set!!"
        EXPIRETIME=1440 # 1 day
    fi

    echo "find ${LOGFILE}* -cmin +${EXPIRETIME} -exec rm -rf {} \;" >> clean_log.sh
done

echo "}
" >> clean_log.sh

echo "
while (true)
do
    sleep 1800
    clean_log
done
" >> clean_log.sh
