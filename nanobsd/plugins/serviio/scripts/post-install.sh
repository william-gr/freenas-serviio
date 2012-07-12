#!/bin/sh

#su admin  (Can't start X as root)
#export DISPLAY=ip-address-of-remote-display:0.0   (IP of your PC running Cygwin-X)
#cd /usr/local/jdownloader/JDownloader  (Takes several minutes)
#java -Xmx512m -jar jdupdate.jar

echo libz.so.4 libz.so.5 > /etc/libmap.conf

#pw groupadd admin
#pw useradd admin -g admin -G wheel -s /usr/local/bin/bash -d /usr/pbi/serviio-`uname -m`/etc/local -w none

# check if this user/group already exists for the MiniDLNA Plugin

if [ `grep -c dlna /etc/group` -eq 0 ]
then
    pw groupadd dlna
fi

#Check if MiniDLNA is installed, Serviio & MiniDLNA both use this username
#Create a dummy file as a flag to prevent deletion if Serviio is uninstalled

if [ `grep -c dlna /etc/passwd` -eq 1 ]
then
    touch DLNA.exists
fi

if [ `grep -c dlna /etc/passwd` -eq 0 ]
then
    pw useradd dlna -g dlna -G wheel -s /usr/local/bin/bash -d /usr/pbi/serviio-`uname -m`/MEDIA -w none
fi


# For JDownloade only, set this in the GUI
#export DISPLAY=ip.address.of.display:0.0
#java -Xmx512m -jar jdupdate.jar

chmod 775 /usr/pbi/serviio-`uname -m`/var/log
chmod 775 /usr/pbi/serviio-`uname -m`/var/db
chmod 775 /usr/pbi/serviio-`uname -m`/etc/mail
chmod 664 /usr/pbi/serviio-`uname -m`/etc/mail/aliases

chown dlna:dlna /usr/pbi/serviio-`uname -m`/MEDIA
chmod 775 /usr/pbi/serviio-`uname -m`/MEDIA


# Add JAIL_IP into /usr/pbi/sbin/serviiod

JAIL_IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')
`
sed -i '' -e "21a\\
JAVA_OPTS=\"\${JAVA_OPTS} -Dserviio.remoteHost=${JAIL_IP}\"" /usr/pbi/serviio-`uname -m`/sbin/serviiod

#This is a hack for pgrep -f since arguments for java get truncated

sed -i '' -e "s/Xmx384M/Xmx416M/" /usr/pbi/sbin/serviiod

echo 'serviio_flags=""' > /usr/pbi/serviio-`uname -m`/etc/rc.conf
echo 'serviio_flags=""' > /etc/rc.conf

/usr/pbi/serviio-`uname -m`/bin/python /usr/pbi/serviio-`uname -m`/serviioUI/manage.py syncdb --migrate --noinput
