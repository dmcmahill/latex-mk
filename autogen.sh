#! /bin/sh
#
# $Id: autogen.sh,v 1.2 2003/02/26 01:28:17 dan Exp $
#
# Run the various GNU autotools to bootstrap the build
# system.  Should only need to be done once.

# for now avoid using bash as not everyone has that installed
CONFIG_SHELL=/bin/sh
export CONFIG_SHELL

aclocal
#autoheader
automake -a -c --gnu
autoconf

