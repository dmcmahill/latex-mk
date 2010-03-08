#! /bin/sh
#
# $Id: autogen.sh,v 1.5 2010/03/08 18:03:16 dan Exp $
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

echo "You must now run configure"

echo "All done with autogen.sh"

