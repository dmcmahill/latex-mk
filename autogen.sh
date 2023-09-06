#!/bin/sh
#

# Copyright (c) 2020 Dan McMahill
# All rights reserved.
#
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
# 


# a leftover cache from a different version will cause no end of headaches
rm -fr autom4te.cache

############################################################################
#
# aclocal

echo "Checking aclocal version..."
acl_ver=`aclocal --version | awk '{print $NF; exit}'`
echo "    $acl_ver"

echo "Running aclocal..."
aclocal -I m4 $ACLOCAL_FLAGS || exit 1
echo "... done with aclocal."

############################################################################
#
# automake

echo "Checking automake version..."
am_ver=`automake --version | awk '{print $NF; exit}'`
echo "    $am_ver"

echo "Running automake..."
automake --gnu --force --copy --add-missing || exit 1
echo "... done with automake."

############################################################################
#
# autoconf

echo "Checking autoconf version..."
ac_ver=`autoconf --version | awk '{print $NF; exit}'`
echo "    $ac_ver"

echo "Running autoconf..."
autoconf || exit 1
echo "... done with autoconf."

