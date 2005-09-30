#! /bin/sh
#
# $Id: autogen.sh,v 1.4 2005/09/30 00:07:28 dan Exp $
#
# Run the various GNU autotools to bootstrap the build
# system.  Should only need to be done once.

# for now avoid using bash as not everyone has that installed
CONFIG_SHELL=/bin/sh
export CONFIG_SHELL

echo "Running aclocal..."
aclocal $ACLOCAL_FLAGS || exit 1
echo "Done with aclocal"

echo "Running automake..."
automake -a -c --foreign || exit 1
echo "Done with automake"

echo "Running autoconf..."
autoconf || exit 1
echo "Done with autoconf"

echo "Running ./configure $@"
./configure $@ || exit 1
echo "Done with configure"

echo "All done with autogen.sh"

