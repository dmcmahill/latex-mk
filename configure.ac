dnl $Id: configure.ac,v 1.1 2002/05/20 14:25:35 dan Exp $
dnl Process this file with autoconf to produce a configure script.
dnl
dnl Copyright (c) 2002 Dan McMahill
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
dnl  4. The name of the author may not be used to endorse or promote products
dnl     derived from this software without specific prior written permission.
dnl    
dnl  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
dnl  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
dnl  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
dnl  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
dnl  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
dnl  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
dnl  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
dnl  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
dnl  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
dnl  SUCH DAMAGE.
dnl    

AC_INIT(latex.mk.in)
AM_INIT_AUTOMAKE(latex-mk, 0.1)
#AM_CONFIG_HEADER(config.h)

#
# determine host type
#
AC_CANONICAL_HOST


#
# an install program
#
AC_PROG_INSTALL

AC_PATH_PROG(MAKE, gmake make)
AC_ARG_WITH([gnumake],
[  --with-gnumake=scidir    Use the specified GNU make installation.  
                          [default = search for an installed GNU make]],
[
if test "X$with_gnumake" = "Xno" ; then
        SCI_WCALC=""
else
        SCI=$with_gnumake
fi
],
[
AC_PATH_PROG(SCILAB,)
if test "X$SCILAB" != "X" ; then
        AC_MSG_CHECKING([for the  base directory])
        [SCI=`$AWK  '/^[ \t]*SCI[ \t]*=/ {print;}' $SCILAB | sed -e 's;.*SCI.*=;;g' -e 's;\";;g'`]
        AC_MSG_RESULT([$SCI])
else
        SCI_WCALC=""
fi
])


AC_OUTPUT(
	Makefile
	latex.mk
	tgif.mk
)
