## Copyright (C) 2002, 2020 Dan McMahill
## All rights reserved.
##
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

info_TEXINFOS=	latex-mk.texi
pkgdata_DATA=	latex-mk.ps latex-mk.pdf latex-mk.html

html_docs=	${info_TEXINFOS:.texi=.html}
ps_docs=	${info_TEXINFOS:.texi=.ps}
pdf_docs=	${info_TEXINFOS:.texi=.pdf}
dvi_docs=	${info_TEXINFOS:.texi=.dvi}

EXTRA_DIST=	${html_docs} ${ps_docs} ${pdf_docs} ${dvi_docs}

#SUFFIXES=	.html .pdf

DISTCLEANFILES= \
	*.fns \
	*.pdf \
	*.trs \
	*.vrs

# do not split the output, html in particular, into multiple files
AM_MAKEINFOFLAGS=	--no-split

#.ps.pdf:
#	ps2pdf $<
#
# texi2dvi  --build-dir=latex-mk.t2d -o latex-mk.dvi   latex-mk.texi
#.texi.html:
#	$(MAKEINFO) --html --no-split $<

#.PHONY: html
#html: version.texi $(html_docs)

#.PHONY: ps
#ps: version.texi $(ps_docs)

#.PHONY: pdf
#pdf: version.texi $(pdf_docs)

