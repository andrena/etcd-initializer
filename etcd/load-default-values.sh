#!/bin/sh
echo "putting default key-value-pairs into etcd"
# Be careful: In properties file commented key-value pairs will be read out anyways (but with '#')
# $1 is a variable input derived from the 1st argument of the sh-script
ETCD_KEY_VALUE_FILE=$1
#IFS == internal field separator
while IFS="=" read -r KEY VALUE
do
etcdctl put ${KEY} ${VALUE} --endpoints=http://etcd:2380
done < $ETCD_KEY_VALUE_FILE