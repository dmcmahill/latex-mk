## Copyright (C) 2002, 2003, 2004, 2005, 2020 Dan McMahill
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

srcdir=	.
top_srcdir=	.
AWK=	gawk

.PHONY: default
default: all

# the include= is a ':' seperated search path for SSI directives
SHTML_INCLUDE_PATH= $(srcdir)

SHTML_IN=	\
	bugs.shtml \
	faq.shtml \
	history.shtml \
	examples.shtml \
	index.shtml \
	news.shtml  \
	obtaining.shtml 

INCL_FILES=\
	left_column.incl \
	main_footer.incl \
	page_start.incl \
	${BUILT_INCL_FILES}

HTML_OUT=	${SHTML_IN:.shtml=.html}

# add the dependency on the .incl files
${HTML_OUT}: ${INCL_FILES}

# the include= is a ':' seperated search path for SSI directives
SHTML2HTML=	${AWK} -f $(top_srcdir)/utils/shtml2html include=$(SHTML_INCLUDE_PATH)

# All the new suffix rules

.SUFFIXES : .shtml .html

.shtml.html :
	$(SHTML2HTML) $< > $@

.PHONY: show-var
show-var:
	@echo ${${VARNAME}}

.PHONY: clean
clean:
	rm -f *~ ${HTML_OUT} latex-mk.html

favicon.ico: favicon.xpm
	xpmtoppm favicon.xpm | ppmtowinicon > $@

latex-mk.html: ../doc/latex-mk.html
	cd ../doc && gmake latex-mk.html
	cp ../doc/latex-mk.html $@

.PHONY: all
all: ${HTML_OUT} latex-mk.html favicon.ico

upload: all
	rsync  -e ssh -vax --progress --delete  --include-from=./upload_list --exclude='*' ./ latex-mk-web:htdocs/

