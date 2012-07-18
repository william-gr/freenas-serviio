#!/bin/sh

echo libz.so.4 libz.so.5 > /etc/libmap.conf
echo libz.so.4 libz.so.5 > /usr/pbi/serviio-`uname -m`/etc/libmap.conf

# check if this user/group already exists for the MiniDLNA Plugin

#if [ `grep -c dlna /etc/group` -eq 0 ]
#then
#    pw groupadd dlna
#fi

#Check if MiniDLNA is installed, Serviio & MiniDLNA both use this username
#Create a dummy file as a flag to prevent deletion if Serviio is uninstalled

#if [ `grep -c dlna /etc/passwd` -eq 1 ]
#then
    #touch /usr/pbi/serviio-`uname -m`/DLNA.exists
#fi

#if [ `grep -c dlna /etc/passwd` -eq 0 ]
#then
#    pw useradd dlna -g dlna -G wheel -s /usr/local/bin/bash -d /usr/pbi/serviio-`uname -m`/MEDIA -w none
#fi

mkdir -p /usr/pbi/serviio-`uname -m`/etc/serviio/home
pw groupadd dlna
pw useradd dlna -g dlna -G wheel -s /usr/local/bin/bash -d /usr/pbi/serviio-`uname -m`/etc/serviio/home -w none

#chmod 775 /usr/pbi/serviio-`uname -m`/var/log
#chmod 775 /usr/pbi/serviio-`uname -m`/var/db

#chmod 775 /usr/pbi/serviio-`uname -m`/etc/mail
#chmod 664 /usr/pbi/serviio-`uname -m`/etc/mail/aliases

chown dlna:dlna /usr/pbi/serviio-`uname -m`/MEDIA
chmod 775 /usr/pbi/serviio-`uname -m`/MEDIA

# Copy patched RC file over automatically generated one
mkdir -p /usr/pbi/serviio-`uname -m`/etc/rc.d/
chmod 755 /usr/pbi/serviio-`uname -m`/serviio.RC
cp /usr/pbi/serviio-`uname -m`/serviio.RC /usr/pbi/serviio-`uname -m`/etc/rc.d/serviio


# Add JAIL_IP into /usr/pbi/sbin/serviiod
# Probably should add JAIL_IP line into serviiod

JAIL_IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'`

sed -i '' -e "21a\\
JAVA_OPTS=\"\${JAVA_OPTS} -Dserviio.remoteHost=${JAIL_IP}\"" /usr/pbi/serviio-`uname -m`/sbin/serviiod

echo $JAIL_IP"	"`hostname` >> /etc/hosts

echo 'serviio_flags=""' > /usr/pbi/serviio-`uname -m`/etc/rc.conf
echo 'serviio_flags=""' > /etc/rc.conf

/usr/pbi/serviio-`uname -m`/bin/python /usr/pbi/serviio-`uname -m`/serviioUI/manage.py syncdb --migrate --noinput
