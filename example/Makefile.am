## $Id: Makefile.am,v 1.1 2002/09/16 11:12:23 dan Exp $


MKSRCS=	makefile.in
EXFILES= \
	biblio.tex \
	example.tex \
	refs.bib 

BMKFILES=	${MKSRCS:.in=.mk}
GMKFILES=	${MKSRCS:.in=.gmk}

pkgexampledir=		${pkgdatadir}/example
pkgexample_DATA=	${BMKFILES} ${GMKFILES} ${EXFILES}

EXTRA_DIST=	${EXFILES}

DISTCLEANFILES=	\
	${BMKFILES} \
	${GMKFILES}

SUBDIRS=	tgif

SUFFIXES=	.in .mk .gmk

SED_COMMON=	-e 's;@latexmkdatadir@;$(pkgdatadir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${bindir};g' 

SED_COMMON_TEST=	-e 's;@latexmkdatadir@;$(top_srcdir);g' \
	-e 's;@latexmkconfdir@;${sysconfdir};g' \
	-e 's;@latexmkbindir@;${top_srcdir};g' 

.in.mk:
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON} $<  > $@
	sed -e 's/^BMK://g' -e '/^GMK:/d' ${SED_COMMON_TEST} $<  > test_$@

.in.gmk:
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON} $<  > $@
	sed -e 's/^GMK://g' -e '/^BMK:/d' ${SED_COMMON_TEST} $<  > test_$@

