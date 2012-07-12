#!/usr/local/bin/bash
### ================================================================ ###
### Serviio start Script                                              ##
###                                                                   ##
### ================================================================ ###


#SERVIIO_HOME="/usr/pbi/serviio-`uname -m`/etc/local/serviio-0.6.2"
SERVIIO_HOME="/usr/pbi/serviio-amd64/etc/local/serviio-0.6.2"
export SERVIIO_HOME

JAVA="/usr/local/bin/java"

# Setup the classpath
SERVIIO_CLASS_PATH="$SERVIIO_HOME/lib/serviio.jar:$SERVIIO_HOME/lib/derby.jar:$SERVIIO_HOME/lib/jcs.jar:$SERVIIO_HOME/lib/concurrent.jar:$SERVIIO_HOME/lib/freemarker.jar:$SERVIIO_HOME/lib/httpcore.jar:$SERVIIO_HOME/lib/jaudiotagger.jar:$SERVIIO_HOME/lib/jul-to-slf4j.jar:$SERVIIO_HOME/lib/jcl-over-slf4j.jar:$SERVIIO_HOME/lib/log4j.jar:$SERVIIO_HOME/lib/sanselan.jar:$SERVIIO_HOME/lib/slf4j-api.jar:$SERVIIO_HOME/lib/slf4j-log4j12.jar:$SERVIIO_HOME/lib/org.restlet.jar:$SERVIIO_HOME/lib/org.restlet.ext.xstream.jar:$SERVIIO_HOME/lib/xstream.jar:$SERVIIO_HOME/lib/rome.jar:$SERVIIO_HOME/lib/rome-modules.jar:$SERVIIO_HOME/lib/jdom.jar:$SERVIIO_HOME/lib/groovy-all.jar:$SERVIIO_HOME/lib/winp.jar:$SERVIIO_HOME/lib/org.restlet.ext.gson.jar:$SERVIIO_HOME/lib/gson.jar:$SERVIIO_HOME/config"


# Setup Serviio specific properties
# Need to change IP address of "remoteHost" below
#
JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dderby.system.home=$SERVIIO_HOME/library -Dserviio.home=$SERVIIO_HOME -Dderby.stream.error.file=/var/log/derby.log -Dserviio.remoteHost=10.0.10.150 -Dffmpeg.location=/usr/local/bin/ffmpeg"

# Execute the JVM in the foreground
/usr/local/bin/java -Xmx512M $JAVA_OPTS -classpath "$SERVIIO_CLASS_PATH" org.serviio.MediaServer "$@"
