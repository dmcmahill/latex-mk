dnl $Id: acinclude.m4,v 1.3 2003/06/11 11:43:15 dan Exp $
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

AC_DEFUN([AX_PATH_GNU_MAKE],
[#AC_MSG_CHECKING([for GNU make])
gnu_make=
for mk in "$GMAKE" "$MAKE" gmake make gnumake ; do
	if test -n "$mk" ; then
		AC_MSG_CHECKING([if $mk is GNU make >= 3.80])
		tmp=`sh -c "$mk --version" 2> /dev/null | grep GNU`
		if test -z "$tmp" ; then
			AC_MSG_RESULT([no])
		else
			case $tmp in
	                *\ 3.[[8-9]][[0-9]]*|*\ [[4-9]].[[0-9]]*)
				AC_MSG_RESULT([yes])
				gnu_make="$mk"
				break
                	        ;;

			* )
				AC_MSG_RESULT([no])
				;;
	                esac    
		fi
	fi
done
if test -z "$gnu_make" ; then
	AC_MSG_NOTICE([No suitable GNU make found.])
	GMAKE=none
	AC_SUBST(GMAKE)
else
	AC_PATH_PROG(GMAKE, $gnu_make)
fi
])dnl


# Look for BSD make
AC_DEFUN([AX_PATH_BSD_MAKE],
[
cat > tmp.mk << EOF
# include some of the "." commands that we need from a 
# BSD make.
MYVAR= BSDmake
MYFLAG= #defined
test:
.for __tmp__ in \${MYVAR}
.if defined(MYFLAG)
	@echo \${__tmp__}
.endif
.endfor

EOF
bsd_make=
for mk in "$BMAKE" "$MAKE" make bmake nbmake ; do
	if test -n "$mk" ; then
		AC_MSG_CHECKING([if $mk is BSD make])
		echo "$as_me:$LINENO: $1" >&AS_MESSAGE_LOG_FD
		sh -c "$mk -f tmp.mk test"  >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD
		ac_status=$?
		echo "$as_me:$LINENO: \$? = $ac_status" >&AS_MESSAGE_LOG_FD

		tmp=`sh -c "$mk -f tmp.mk test" 2> /dev/null | grep BSDmake`
		if test "X$tmp" = "XBSDmake" ; then
			AC_MSG_RESULT([yes])
			bsd_make="$mk"
			break
		else
			AC_MSG_RESULT([no])
		fi
	fi
done
if test -f tmp.mk ; then rm tmp.mk ; fi
if test -z "$bsd_make" ; then
	AC_MSG_NOTICE([No suitable BSD make found.])
	BMAKE=none
	AC_SUBST(BMAKE)
else
	AC_PATH_PROG(BMAKE, $bsd_make)
fi
])dnl


