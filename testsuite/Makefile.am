## Copyright (c) 2003, 2020 Dan McMahill
## All rights reserved.
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; version 2 of the License.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

TESTS_ENVIRONMENT=	\
	GMAKE=${GMAKE}	\
	BMAKE=${BMAKE}  \
	DIFF_FLAGS="${DIFF_FLAGS}" \
	SHOW_DIFF=yes

MKSRCS=		testfile.mk.in
RUN_TESTS=	run_tests.sh

BMKFILES=	${MKSRCS:.mk.in=.mk}
GMKFILES=	${MKSRCS:.mk.in=.gmk}

#pkgtestdir=	${pkgdatadir}/testsuite
#pkgtest_DATA=	${BMKFILES} ${GMKFILES} tests.list
#pkgtest_SCRIPTS=	${RUN_TESTS}

check_SCRIPTS=		${RUN_TESTS}
check_DATA=		${BMKFILES} ${GMKFILES}

DISTCLEANFILES=	\
	configure.lineno \
	${BMKFILES} \
	${GMKFILES}

SUBDIRS=	bmake_ref gmake_ref

TESTS=		${RUN_TESTS}

EXTRA_DIST=	${MKSRCS} ${RUN_TESTS} tests.list golden.mk README.txt \
		sort_sections.awk

SUFFIXES=	.mk.in .mk .gmk

SED_COMMON=	-e 's;@pkgdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${bindir};g'

.mk.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.mk.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@
