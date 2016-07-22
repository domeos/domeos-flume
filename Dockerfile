FROM private-registry.sohucs.com/sohucs/jdk:7

RUN yum install -y tar && \
    yum clean all
RUN mkdir -p /opt; cd /opt; curl http://dl.domeos.org/Deps/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz -O \
&&	tar zxvf apache-flume-1.6.0-bin.tar.gz \
&&	rm  -f apache-flume-1.6.0-bin.tar.gz

RUN for i in `seq 1 15`; do mkdir -p /opt/outlog/logdir$i; done
ADD . /opt/apache-flume-1.6.0-bin

CMD cd /opt/apache-flume-1.6.0-bin; sh /opt/apache-flume-1.6.0-bin/domeos.sh

