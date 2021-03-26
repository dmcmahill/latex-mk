## Copyright (C) 2002, 2020, 2021 Dan McMahill
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

MKSRCS=	latex.mk.in tgif.mk.in virtuoso.mk.in xfig.mk.in

BMKFILES=	${MKSRCS:.mk.in=.mk}
GMKFILES=	${MKSRCS:.mk.in=.gmk}
PSFILES=	dated_draft.ps

pkgdata_DATA=	${BMKFILES} ${GMKFILES} ${PSFILES}
bin_SCRIPTS=	latex-mk latex-mk-virtuoso ieee-copyout

DISTCLEANFILES=	\
	configure.lineno \
	${BMKFILES} \
	${GMKFILES}

EXTRA_DIST=	${PSFILES} TODO

SUBDIRS=	doc example testsuite

SUFFIXES=	.mk.in .mk .gmk

SED_COMMON=	-e 's;@pkgdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${bindir};g'

# make sure the latex-mk script is executible before installation so we
# can give it a trial run here

all-local:
	chmod 755 latex-mk
	chmod 755 latex-mk-virtuoso
	chmod 755 ieee-copyout

.mk.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.mk.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@

