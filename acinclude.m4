dnl $Id: acinclude.m4,v 1.1 2003/06/04 14:12:19 dan Exp $
dnl
dnl Copyright (c) 2003 Dan McMahill
dnl All rights reserved.
dnl
dnl This code is derived from software written by Dan McMahill
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions
dnl are met:
dnl 1. Redistributions of source code must retain the above copyright
dnl    notice, this list of conditions and the following disclaimer.
dnl 2. Redistributions in binary form must reproduce the above copyright
dnl    notice, this list of conditions and the following disclaimer in the
dnl    documentation and/or other materials provided with the distribution.
dnl 3. All advertising materials mentioning features or use of this software
dnl    must display the following acknowledgement:
dnl        This product includes software developed by Dan McMahill
dnl 4. The name of the author may not be used to endorse or promote products
dnl    derived from this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
dnl IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
dnl OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
dnl IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
dnl INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
dnl BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
dnl LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
dnl AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
dnl OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
dnl SUCH DAMAGE.
dnl

# Look for GNU make

AC_DEFUN(AC_PATH_GNU_MAKE,
[#AC_MSG_CHECKING([for GNU make])
for mk in $MAKE gmake make ; do
	AC_PATH_PROG(GMAKE, $mk)
	if test "X$GMAKE" != "X" ; then
		AC_MSG_CHECKING([if $GMAKE is GNU make])
		tmp=`$GMAKE --version 2>&1`
		if false ; then
			AC_MSG_RESULT([no])
			GMAKE=
		else
			AC_MSG_RESULT([yes])
		fi
	fi
done
])dnl


# Look for BSD make
AC_DEFUN(AC_PATH_BSD_MAKE,
[AC_MSG_CHECKING([for BSD make])
for mk in $MAKE make bmake nbmake ; do
	AC_MSG_CHECKING([if $mk is BSD make])
	if false ; then
		AC_MSG_RESULT([no])
	else
		AC_MSG_RESULT([yes])
	fi
done
])dnl


