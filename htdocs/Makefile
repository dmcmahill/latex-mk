## $Id: Makefile,v 1.7 2004/03/19 02:28:05 dan Exp $
##

## Copyright (c) 2002, 2003, 2004 Dan McMahill
## All rights reserved.
##
## This code is derived from software written by Dan McMahill
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
## 3. All advertising materials mentioning features or use of this software
##    must display the following acknowledgement:
##        This product includes software developed by Dan McMahill
##  4. The name of the author may not be used to endorse or promote products
##     derived from this software without specific prior written permission.
## 
##  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
##  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
##  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
##  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
##  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
##  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
##  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
##  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
##  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
##  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
##  SUCH DAMAGE.
##


srcdir=	.
top_srcdir=	.
AWK=	awk

.PHONY: all
all: ${HTML_OUT} favicon.ico

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
${HTML_OUT} : ${INCL_FILES}

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
	rm -f *~ ${HTML_OUT}

favicon.ico: favicon.xpm
	xpmtoppm favicon.xpm | ppmtowinicon > $@

latex-mk.html: ../doc/latex-mk.html
	cd ../doc && gmake latex-mk.html
	cp ../doc/latex-mk.html $@

upload: all
	rsync  -e ssh -vax --progress --delete  --include-from=./upload_list --exclude='*' . danmc@shell.sourceforge.net:/home/groups/l/la/latex-mk/htdocs

