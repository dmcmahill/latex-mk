## $Id: Makefile.am,v 1.6 2002/09/14 11:34:18 dan Exp $


MKSRCS=	latex.mk.in tgif.mk.in xfig.mk.in

BMKFILES=	${MKSRCS:.mk.in=.mk}
GMKFILES=	${MKSRCS:.mk.in=.gmk}

pkgdata_DATA=	${BMKFILES} ${GMKFILES}
bin_SCRIPTS=	latex-mk

DISTCLEANFILES=	\
	configure.lineno \
	${BMKFILES} \
	${GMKFILES}

SUBDIRS=	doc

SUFFIXES=	.mk.in .mk .gmk

SED_COMMON=	-e 's;@pkgdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g'

.mk.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.mk.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@

