#!/bin/sh

# New strategy, put syncdb first to see if it works here
/usr/pbi/serviio-`uname -m`/bin/python /usr/pbi/serviio-`uname -m`/serviioUI/manage.py syncdb --migrate --noinput

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
mv /usr/pbi/serviio-`uname -m`/serviio.RC /usr/pbi/serviio-`uname -m`/etc/rc.d/serviio

# The following 2 sed commands let Serviio determine the Jail IP address and add it to the JAVA_OPTS used to start Serviio

sed -i '' -e "21a\\
JAIL_IP=\`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}\'" /usr/pbi/serviio-`uname -m`/sbin/serviiod

sed -i '' -e "22a\\
JAVA_OPTS=\"\${JAVA_OPTS} -Dserviio.remoteHost=${JAIL_IP}\"" /usr/pbi/serviio-`uname -m`/sbin/serviiod


# Need to improve this in case hostname had another ip address or address had a different hostname
if [ `grep -c $JAIL_IP /etc/hosts` -eq 0 ]
    echo $JAIL_IP"	"`hostname` >> /etc/hosts
fi

echo 'serviio_flags=""' > /usr/pbi/serviio-`uname -m`/etc/rc.conf
echo 'serviio_flags=""' > /etc/rc.conf
