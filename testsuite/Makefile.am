## $Id: Makefile.am,v 1.8 2003/02/08 21:42:18 dan Exp $
##
## Copyright (c) 2003 Dan McMahill
## All rights reserved.
##
## This code is derived from software written by Dan McMahill
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
## 3. All advertising materials mentioning features or use of this software
##    must display the following acknowledgement:
##        This product includes software developed by Dan McMahill
##  4. The name of the author may not be used to endorse or promote products
##     derived from this software without specific prior written permission.
## 
##  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
##  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
##  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
##  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
##  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
##  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
##  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
##  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
##  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
##  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
##  SUCH DAMAGE.
##

MKSRCS=		testfile.mk.in
RUN_TESTS=	run_tests.sh

BMKFILES=	${MKSRCS:.mk.in=.mk}
GMKFILES=	${MKSRCS:.mk.in=.gmk}

pkgtestdir=	${pkgdatadir}/testsuite
pkgtest_DATA=	${BMKFILES} ${GMKFILES} tests.list
pkgtest_SCRIPTS=	${RUN_TESTS}

check_SCRIPTS=		${RUN_TESTS}

DISTCLEANFILES=	\
	configure.lineno \
	${BMKFILES} \
	${GMKFILES}

SUBDIRS=	bmake_ref gmake_ref

TESTS=		${RUN_TESTS}

EXTRA_DIST=	${MKSRCS} ${RUN_TESTS} tests.list golden.mk

SUFFIXES=	.mk.in .mk .gmk

SED_COMMON=	-e 's;@pkgdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${bindir};g'

.mk.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.mk.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@