#!/bin/sh

clearTables(){
    echo "clearTables!!"
    echo "" > /data/filterTables
    filterNum=`iptables -S |grep FORWARD | grep bridge0 | grep -v INVALID | wc -l`

    i=1
    while [ $i -le $filterNum ]
    do
        `iptables -S |grep FORWARD | grep bridge0 | grep -v INVALID | sed 's/-A/iptables -D/' | sed -n "1p"`
        let i++
    done
}

if [ ! -f "/data/filterMode" ];then
    echo "Create Quectel Filter Mode File"
    echo 0 > /data/filterMode
fi

if [ ! -f "/data/filterTables" ];then
    echo "Create Quectel Filter Tables"
    touch /data/filterTables
fi

if [ "$1" = "" ]; then
    FilterMode=`cat /data/filterMode`
    FirstPowerFlag=1
else
    FilterMode=$1
    FirstPowerFlag=0
fi

if [ "$FilterMode" = "1" ]; then
    echo "Enable Quectel Black List"
    if [ "$FirstPowerFlag" = "0" ]; then
        clearTables
        ip6tables -P FORWARD ACCEPT
        echo 1 > /data/filterMode
    fi
elif [ "$FilterMode" = "2" ]; then
    echo "Enable Quectel White List"
    if [ "$FirstPowerFlag" = "0" ]; then
        clearTables
        echo "iptables -P FORWARD DROP" > /data/filterTables
        echo "ip6tables -P FORWARD DROP" >> /data/filterTables
        echo 2 > /data/filterMode
    fi
elif [ "$FilterMode" = "0" ]; then
    echo "Disable Quectel Filter Set Function"
    if [ "$FirstPowerFlag" = "0" ]; then
        clearTables
        ip6tables -P FORWARD ACCEPT
        echo 0 > /data/filterMode
    fi
fi
while read -r line
do
    $line
done < /data/filterTables

