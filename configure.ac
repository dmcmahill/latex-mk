dnl Process this file with autoconf to produce a configure script.
dnl
dnl Copyright (c) 2002, 2003, 2004, 2005, 2006, 2007, 2010, 2025 Dan McMahill
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

m4_define([latex_mk_version],
          m4_esyscmd([./build-helpers/package-version.sh . version-stamp]))
AC_INIT([latex-mk],
        [m4_defn([latex_mk_version])],
        [https://github.com/dmcmahill/latex-mk/issues],
        [latex-mk],
        [https://github.com/dmcmahill/latex-mk])

AC_CONFIG_SRCDIR([latex.mk.in.in])
AM_INIT_AUTOMAKE

#
# determine host type
#
AC_CANONICAL_HOST

#
# an install program
#
AC_PROG_INSTALL

#
# general
#
AC_PATH_PROG(AWK, awk nawk gawk mawk, awk)
AC_PATH_PROG(SED, gsed sed, sed)
AC_PATH_PROG(ENV_PROG, env, env)
AC_PATH_PROG(FALSE, false, false)
AC_PATH_PROG(GREP, grep, grep)
AC_PATH_PROG(GZCAT, gzcat, gzcat)
AC_PATH_PROG(GZIP, gzip, gzip)
AC_PATH_PROG(RM, rm, rm)
AC_PATH_PROG(RMDIR, rmdir, rmdir)
AC_PATH_PROG(TAR, tar, tar)

AX_PROG_DIFF

#
# for latex.mk
#
AC_PATH_PROG(BIBTEX, bibtex, bibtex)
# for converting graphics file formats (from ImageMagick)
AC_PATH_PROG(CONVERT, convert, convert)
AC_PATH_PROG(DVIPDFM, dvipdfm, dvipdfm)
AC_PATH_PROG(DVIPS, dvips, dvips)
AC_PATH_PROG(ECHO, echo, echo)
AC_PATH_PROG(FIND, find, find)
AC_PATH_PROG(GV, gv, gv)
AC_PATH_PROG(HEVEA, hevea, hevea)
AC_PATH_PROG(HACHA, hacha, hacha)
AC_PATH_PROG(IMAGEN, imagen, imagen)
AC_PATH_PROG(LATEX, latex, latex)
AC_PATH_PROG(LATEX2HTML, latex2html, latex2html)
AC_PATH_PROG(LATEX2RTF, latex2rtf, latex2rtf)
AC_PATH_PROG(LPR, lpr, lpr)
AC_PATH_PROG(MAKEIDX, makeindex, makeindex)
AC_PATH_PROG(PDFLATEX, pdflatex, pdflatex)
AC_PATH_PROG(PS2PDF, ps2pdf, ps2pdf)
AC_PATH_PROG(TEX2PAGE, tex2page, tex2page)
AC_PATH_PROG(XDVI, xdvi, xdvi)

#
# for lgrind.mk
#
AC_PATH_PROG(LGRIND, lgrind, lgrind)

#
# for mpost.mk
#
AC_PATH_PROG(MPOST, mpost mp, mpost)

#
# for tgif.mk
#
AC_PATH_PROG(TGIF, tgif, tgif)

#
# for xfig.mk
#
AC_PATH_PROG(FIG2DEV, fig2dev, fig2dev)

#
# Look for a GNU make program and a BSD make program
# This is used by the testsuite
#

AX_PATH_GNU_MAKE
AX_PATH_BSD_MAKE

if test "X${BMAKE}" = "Xnone" -a "X${GMAKE}" = "Xnone" ; then
	AC_MSG_NOTICE([

************************ WARNING ************************
I could not find GNU make >= version 3.80 _or_
a suitable BSD make on your system.  This package
will still install correctly, but you will not actually
be able to use it or run the testsuite until you 
install a suitable make program.
************************ WARNING ************************

]
)
fi

#
# system config files
#

AC_ARG_WITH([mkconf],
[  --with-mkconf=mkconf    Use the specified file as the site configuration
                          file for BSD make.  [default = /etc/latex-mk.conf]],
[
if test "X$with_mkconf" = "Xno" ; then
        AC_MSG_ERROR(--without-mkconf is not supported)
else
        MAKECONF="$with_mkconf"
fi
],
[
MAKECONF=@latexmkconfdir@/latex-mk.conf
])
AC_SUBST(MAKECONF)

AC_ARG_WITH([gmkconf],
[  --with-gmkconf=gmkconf  Use the specified file as the site configuration
                          file for GNU make.  [default = /etc/latex-gmk.conf]],
[
if test "X$with_gmkconf" = "Xno" ; then
        AC_MSG_ERROR(--without-gmkconf is not supported)
else
        GMAKECONF="$with_gmkconf"
fi
],
[
GMAKECONF=@latexmkconfdir@/latex-gmk.conf
])
AC_SUBST(GMAKECONF)


AC_ARG_WITH([usermkconf],
[  --with-mkconf=usermkconf
                          Use the specified file as the site configuration
                          file for BSD make.  [default = $HOME/.latex-mk.conf]],
[
if test "X$with_usermkconf" = "Xno" ; then
        AC_MSG_ERROR(--without-usermkconf is not supported)
else
        USERMAKECONF="$with_usermkconf"
fi
],
[
USERMAKECONF="\${HOME}/.latex-mk.conf"
])
AC_SUBST(USERMAKECONF)

AC_ARG_WITH([usergmkconf],
[  --with-usergmkconf=usergmkconf
                          Use the specified file as the user configuration
                          file for GNU make.  [default = $HOME/.latex-gmk.conf]],
[
if test "X$with_usergmkconf" = "Xno" ; then
        AC_MSG_ERROR(--without-usergmkconf is not supported)
else
        USERGMAKECONF="$with_usergmkconf"
fi
],
[
USERGMAKECONF="\${HOME}/.latex-gmk.conf"
])
AC_SUBST(USERGMAKECONF)


AC_CONFIG_FILES([Makefile
	doc/Makefile
	doc/prefix.texi
	example/Makefile
	example/tgif/Makefile
	ieee-copyout
	latex-mk
	latex.mk.in
	latex.subdir.mk.in
	lgrind.mk.in
	mpost.mk.in
	testsuite/Makefile
	testsuite/bmake_ref/Makefile
	testsuite/gmake_ref/Makefile
	testsuite/latex_mk_ref/Makefile
	tgif.mk.in
	xfig.mk.in
])
AC_OUTPUT
