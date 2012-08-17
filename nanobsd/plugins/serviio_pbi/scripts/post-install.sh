#!/bin/sh

SERVIIO_HOME=/usr/pbi/serviio-`uname -m`

# New strategy, put syncdb first to see if it works here
env -i ${SERVIIO_HOME}/bin/python ${SERVIIO_HOME}/serviioUI/manage.py syncdb --migrate --noinput

echo libz.so.4 libz.so.5 > /etc/libmap.conf
echo libz.so.4 libz.so.5 > ${SERVIIO_HOME}/etc/libmap.conf

# check if this user/group already exists for the MiniDLNA Plugin

#if [ `grep -c dlna /etc/group` -eq 0 ]
#then
#    pw groupadd dlna
#fi

#Check if MiniDLNA is installed, Serviio & MiniDLNA both use this username
#Create a dummy file as a flag to prevent deletion if Serviio is uninstalled

#if [ `grep -c dlna /etc/passwd` -eq 1 ]
#then
    #touch ${SERVIIO_HOME}/DLNA.exists
#fi

#if [ `grep -c dlna /etc/passwd` -eq 0 ]
#then
#    pw useradd dlna -g dlna -G wheel -s /usr/local/bin/bash -d ${SERVIIO_HOME}/MEDIA -w none
#fi

mkdir -p ${SERVIIO_HOME}/etc/serviio/home
pw groupadd dlna
pw useradd dlna -g dlna -G wheel -s /usr/local/bin/bash -d ${SERVIIO_HOME}/etc/serviio/home -w none

# Fixes HD transcoding error reported in forums
if [ ! -e /var/tmp ]; then
    mkdir -p /var/tmp 
fi

if [ ! -e ${SERVIIO_HOME}/var/tmp ]; then
    mkdir -p ${SERVIIO_HOME}/var
    ln -s /var/tmp ${SERVIIO_HOME}/var/tmp         
fi

if [ ! -e /var/db/serviio ]; then
    mkdir -p /var/db/serviio
    chown -R dlna:dlna /var/db/serviio
fi

chown dlna:dlna ${SERVIIO_HOME}/MEDIA
chmod 775 ${SERVIIO_HOME}/MEDIA

# Copy patched RC file over automatically generated one
mkdir -p ${SERVIIO_HOME}/etc/rc.d/
chmod 755 ${SERVIIO_HOME}/serviio.RC
mv ${SERVIIO_HOME}/serviio.RC ${SERVIIO_HOME}/etc/rc.d/serviio

# The following 2 sed commands let Serviio determine the Jail IP address and add it to the JAVA_OPTS used to start Serviio

sed -i '' -e "21a\\
JAIL_IP=\`ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'\`" ${SERVIIO_HOME}/sbin/serviiod

sed -i '' -e "22a\\
JAVA_OPTS=\"\${JAVA_OPTS} -Dserviio.remoteHost=\${JAIL_IP}\"" ${SERVIIO_HOME}/sbin/serviiod

sed -i '' -e "s,exec java,exec ${SERVIIO_HOME}/bin/java,g" ${SERVIIO_HOME}/sbin/serviiod


#if [ `grep -c $JAIL_IP /etc/hosts` -eq 0 ]
#fi

echo $JAIL_IP"	"`hostname` >> /etc/hosts

echo 'serviio_flags=""' > ${SERVIIO_HOME}/etc/rc.conf
echo 'serviio_flags=""' > /etc/rc.conf

# Create TEST video from uuencoded archive
uudecode -i -o ${SERVIIO_HOME}/TEST/ServiioTest.mp4 ${SERVIIO_HOME}/TEST/ServiioTest.uue
rm ${SERVIIO_HOME}/TEST/ServiioTest.uue
