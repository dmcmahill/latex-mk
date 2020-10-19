dnl Copyright (c) 2003, 2020 Dan McMahill
dnl All rights reserved.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; version 2 of the License.
dnl 
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl 
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

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

##########################################################################
#
# diff program and flags (used by the testsuite)
#

# find the diff program
AC_DEFUN([AX_PATH_DIFF],
  [AC_PATH_PROGS(DIFF, diff gdiff, diff)
  AC_PROVIDE([AX_PATH_DIFF])dnl
])

# checks on DIFF flags
dnl AX_TRY_DIFF(FLAG, MATCHED, [ACTION-IF-TRUE [, ACTION-IF-FALSE]])
dnl MATCHED is one of [yes] or [no] to indicate that the input
dnl files for the test should match ([yes]) or not match ([no])
AC_DEFUN([AX_TRY_DIFF],
[AC_REQUIRE([AX_PATH_DIFF])dnl
cat > conftest1.txt <<EOF
[#]line __oline__ "configure"
this is a text file
that has some line
and another
EOF
cat > conftest2.txt <<EOF
[#]line __oline__ "configure"
this is a text file
that has a different line
and another
EOF
if test "X[$2]" = "Xyes" ; then
    cp conftest1.txt conftest2.txt
fi
if ($DIFF [$1] conftest1.txt conftest2.txt >/dev/null; exit) 2>&AC_FD_CC
then
dnl
  AC_MSG_RESULT([yes])
  ifelse([$3], , :, [$3])
else
  AC_MSG_RESULT([no])
  echo "configure:__oline__: $DIFF [$1] conftest1.txt conftest2.txt" >&AC_FD_CC
  echo "configure:__oline__: failed input file conftest1.txt  was:" >&AC_FD_CC
  cat conftest1.txt >&AC_FD_CC
  echo "configure:__oline__: failed input file conftest2.txt  was:" >&AC_FD_CC
  cat conftest2.txt >&AC_FD_CC
ifelse([$4], , , [  rm -fr conftest*
  $3
])dnl
fi
rm -fr conftest*])


# top level DIFF
dnl AX_PROG_DIFF
AC_DEFUN([AX_PROG_DIFF],
[
DIFF_FLAGS=${DIFF_FLAGS:-}
for flag in -U2 ; do
    AC_MSG_CHECKING([if $DIFF accepts $flag])
    AX_TRY_DIFF([$flag], [yes], DIFF_FLAGS="${DIFF_FLAGS} ${flag}")
done
AC_SUBST(DIFF_FLAGS)
])dnl

