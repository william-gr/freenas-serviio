FreeNAS_8-Serviio
=====================

Build Notes:

Even if you use OpenJDK, Diablo_JRE is still required to compile it.
This means you still need to get:

diablo-caffe-freebsd7-amd64-1.6.0_07-b02.tar.bz2
diablo-caffe-freebsd7-i386-1.6.0_07-b02.tar.bz2
diablo-jdk-freebsd7.amd64.1.6.0.07.02.tbz
diablo-latte-freebsd7-i386-1.6.0_07-b02.tar.bz2
tzupdater-1_3_45-2011n.zip

Download them from here:

http://www.freebsdfoundation.org/downloads/java16.shtml

and put them in FreeBSD/ports/distfiles of your FreeNAS source tree.

Keep in mind you will need both the i386 and amd64 versions
if you are going to create plugins for both architectures.
It's also a good idea to backup those distfile to the main distfiles
directory in /usr/ports/distfiles

Remember, the ports for PBI's are being built for FreeBSD 8.0,
so a lot of the ports are outdated and could cause problems if the
wrong ones are updated.

Sometimes the parallel builds will bite you because somethings won't
be built by the time something that depends on it needs it. So it's
helpful to use "-j 1" when you build the plugin, for example:

sh build/do_build -j 1 -t plugins/serviio

You'll need to cd to the ports directory in your FreeNAS source tree
and run "make config" in ports/multimedia/ffmpeg and make sure to
select the following options, some are the default, ones with an
asterix are optional but required:

FFSERVER
FONTCONFIG
FREETYPE
FREI0R
GNUTLS
* LAME
OPENCV
* OPENJPEG
* RTMP
SCHROEDINGER
THEORA
VORBIS
* VPX
X264
XVID

You'll need to update these ports:

multimedia/rtmpdump to 2.41


After you grab the FreeNAS source tree, you'll need to edit a
couple of the scripts and add a "target" for Serviio. They are:

8.2.0/build/do_build.sh
8.2.0/nanobsd/plugins/Makefile
