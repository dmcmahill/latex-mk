## $Id: Makefile.am,v 1.5 2002/08/22 03:13:45 dan Exp $

info_TEXINFOS=	latex-mk.texi

html_docs=	${info_TEXINFOS:.texi=.html}
ps_docs=	${info_TEXINFOS:.texi=.ps}
pdf_docs=	${info_TEXINFOS:.texi=.pdf}

EXTRA_DIST=	${html_docs} ${ps_docs} ${pdf_docs}

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

