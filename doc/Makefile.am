## $Id: Makefile.am,v 1.7 2002/10/07 21:15:59 dan Exp $

info_TEXINFOS=	latex-mk.texi
pkgdata_DATA=	latex-mk.ps latex-mk.pdf latex-mk.html

html_docs=	${info_TEXINFOS:.texi=.html}
ps_docs=	${info_TEXINFOS:.texi=.ps}
pdf_docs=	${info_TEXINFOS:.texi=.pdf}
dvi_docs=	${info_TEXINFOS:.texi=.dvi}

EXTRA_DIST=	${html_docs} ${ps_docs} ${pdf_docs} ${dvi_docs}

SUFFIXES=	.html .pdf

DISTCLEANFILES= \
	*.fns \
	*.pdf \
	*.trs \
	*.vrs

.ps.pdf:
	ps2pdf $<

.texi.html:
	$(MAKEINFO) --html $<

.PHONY: html
html: version.texi $(html_docs)

.PHONY: ps
ps: version.texi $(ps_docs)

.PHONY: pdf
pdf: version.texi $(pdf_docs)

