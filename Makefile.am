## $Id: Makefile.am,v 1.3 2002/08/15 02:50:28 dan Exp $


MKSRCS=	latex.mk.in tgif.mk.in xfig.mk.in

BMKFILES=	${MKSRCS:.mk.in=.mk}
GMKFILES=	${MKSRCS:.mk.in=.gmk}

pkgdata_DATA= ${BMKFILES} ${GMKFILES}

EXTRA_DIST= ${MKSRCS}
DISTCLEANFILES=	\
	configure.lineno \
	${BMKFILES} \
	${GMKFILES}

SUBDIRS=	doc

SUFFIXES=	.mk.in .mk .gmk

SED_COMMON=	-e 's;@pkgdatadir@;$(pkgdatadir);g'

.mk.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@

.mk.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@

