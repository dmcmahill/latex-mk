## Copyright (c) 2002, 2003, 2020 Dan McMahill
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

MKSRCS=	mkfile.in
EXFILES= \
	biblio.tex \
	example.tex \
	ex2.tex \
	ex3.tex \
	refs.bib 

BMKFILES=	${MKSRCS:.in=.mk}
GMKFILES=	${MKSRCS:.in=.gmk}

pkgexampledir=		${pkgdatadir}/example
pkgexample_DATA=	${BMKFILES} ${GMKFILES} ${EXFILES} README-example.txt

EXTRA_DIST=	${EXFILES} ${MKSRCS} README-example.txt

DISTCLEANFILES=	\
	${BMKFILES} \
	${GMKFILES} \
	example.conf

SUBDIRS=	tgif

SUFFIXES=	.in .mk .gmk

SED_COMMON=	-e 's;@latexmkdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${bindir};g' \
	-e '/^MAKECONF/d'

SED_COMMON_TEST=	-e 's;@latexmkdatadir@;$(top_srcdir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${top_srcdir};g' 

.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@

