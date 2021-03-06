#!/bin/bash

echo "installing Hostapd/Karma Dependencies..."
# DEP HOSTAPD-KARMA
apt-get -y install gcc-4.7
apt-get -y install g++-4.7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7

apt-get -y install hostapd
apt-get -y install libnl1 libnl-dev libssl-dev

echo "installing Hostapd/Karma..."
# INSTALL HOSTAPD-KARMA
#wget http://www.digininja.org/files/hostapd-1.0-karma.tar.bz2 -O hostapd-1.0-karma.tar.bz2

#bunzip2 hostapd-1.0-karma.tar.bz2
#tar xvf hostapd-1.0-karma.tar
#cd hostapd-1.0-karma/hostapd
#make

wget https://github.com/xtr4nge/hostapd-karma/archive/master.zip -O hostapd-karma.zip

unzip hostapd-karma.zip

cmd=`lsb_release -c |grep -iEe "jessie|kali|sana"`
if [[ ! -z $cmd ]]
then
    echo "--------------------------------"
    echo "ADDING: CONFIG_LIBNL32=y (Debian Jessie|Kali patch)"
    echo "--------------------------------"
    
    apt-get -y install libnl-3-dev libnl-genl-3-dev
    
    EXEC="s,^#CFLAGS += -I/usr/include/libnl3,CFLAGS += -I/usr/include/libnl3,g"
    sed -i "$EXEC" hostapd-karma-master/hostapd/.config
    
    EXEC="s,^#CONFIG_LIBNL32=y,CONFIG_LIBNL32=y,g"
    sed -i "$EXEC" hostapd-karma-master/hostapd/.config
    
    echo "[setup completed]"
    echo

fi

cd hostapd-karma-master/hostapd
make


cp hostapd ../../
cp hostapd_cli ../../

echo "..DONE.."
exit
