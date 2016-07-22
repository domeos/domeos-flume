#!/bin/sh

image=sohucs/domeos-flume
tag=1.0
#domain=10.11.150.76:5000
domain=private-registry.sohucs.com
docker build -t $domain/$image:$tag .
