## $Id: Makefile.am,v 1.1 2002/05/21 01:50:05 dan Exp $

info_TEXINFOS=	latex-mk.texi

html_docs=	latex-mk.html
ps_docs=	latex-mk.ps
pdf_docs=	latex-mk.pdf

EXTRA_DIST=	${html_docs} ${ps_docs} ${pdf_docs}

SUFFIXES=	.html .pdf

.ps.pdf:
	ps2pdf $<

.texi.html:
	$(MAKEINFO) --html $<

.PHONY: html ps pdf
html: version.texi $(html_docs)
ps: version.texi $(ps_docs)
pdf: version.texi $(pdf_docs)

