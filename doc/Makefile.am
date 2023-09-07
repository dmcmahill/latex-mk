## Copyright (C) 2002, 2005, 2006, 2010, 2020, 2023 Dan McMahill
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
dist_pkgdata_DATA=	${html_docs} ${pdf_docs}

html_docs=	${info_TEXINFOS:.texi=.html}
pdf_docs=	${info_TEXINFOS:.texi=.pdf}

# put the html manual into 1 file instead of multiple files
AM_MAKEINFOHTMLFLAGS=  --no-split

# use this to avoid having the clean target delete latex-mk.{dvi,html,pdf,ps}
# which unfortunately deletes files which are part of the distfile
#mostlyclean-aminfo:
#	-rm -rf latex-mk.aux latex-mk.cp latex-mk.cps latex-mk.fn \
#		latex-mk.fns latex-mk.ky latex-mk.kys latex-mk.log \
#		latex-mk.pg latex-mk.pgs latex-mk.tmp latex-mk.toc \
#		latex-mk.tp latex-mk.tps latex-mk.vr latex-mk.vrs 

#MAINTAINERCLEANFILES= \
#	${html_docs} ${ps_docs} ${pdf_docs} ${dvi_docs}
