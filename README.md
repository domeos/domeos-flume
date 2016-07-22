# DomeOS的标准日志收集组件-flume
## 基础
使用flume1.6版本，使用tail -F获取日志信息，并上报到kafka中，所有信息通过环境变量导入，使用脚本生成配置文件
## 环境变量，示例如下：
DOMEOS\_FLUME\_LOG_COUNT=2  
DOMEOS\_FLUME\_LOGFILE1=/log/xxx.log  
DOMEOS\_FLUME\_TOPIC1=log1  
DOMEOS\_FLUME\_MORECMD1=" | grep "ERROR\\|FATAL" | awk -vnhost="$HOSTNAME" '{print "["nhost"]—"$0}'  
DOMEOS\_FLUME\_LOGFILE2=/log/xxx2.log  
DOMEOS\_FLUME\_TOPIC2=log2  
DOMEOS\_KAFKA\_BROKER=xx.xx.xx.xx:xxxx  
DOMEOS\_FLUME\_CHANNEL_DIR=/log/  

# DomeOS的标准日志清理组件-cleanlog
## 环境变量，示例如下：
DOMEOS\_CLEAN\_LOG_COUNT=2  
DOMEOS\_CLEAN\_LOGFILE1=/log/xxx.log  
DOMEOS\_CLEAN\_EXPIRETIME1=7200 # 单位分钟  
DOMEOS\_CLEAN\_LOGFILE2=/log/xxx.log  
DOMEOS\_CLEAN\_EXPIRETIME2=3600 # 单位分钟