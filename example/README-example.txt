# $Id: README-example.txt,v 1.2 2002/10/09 03:13:50 dan Exp $
#


----------------------------------------
Trying the example before installation
----------------------------------------

To try out LaTeX-Mk and this example before installation, you need to set the 
following environment variables:

LATEX_MK_DIR

    This should be set to the top level build directory for LaTeX-Mk.  In
    this example, assume that the sources were extracted and built in 
    /tmp/latex-mk-0.2

LATEX-MK

    This should be set to the complete path to the latex-mk script.


If you are using csh/tcsh:

setenv LATEX_MK_DIR /tmp/latex-mk-0.2
setenv LATEX-MK /tmp/latex-mk-0.2/latex-mk

In you are using sh/bash:

LATEX_MK_DIR=/tmp/latex-mk-0.2
export LATEX_MK_DIR
LATEX-MK=/tmp/latex-mk-0.2/latex-mk
export LATEX-MK

Now go to the "running the example" section.

----------------------------------------
Trying the example after installation
----------------------------------------

If you wish to try out the example after installation, you will need to
copy the examples directory to a working directory where you have write
permissions.  Assuming that the examples directory was installed to
/usr/local/share/latex-mk/example, you can do something like:

mkdir /some/tmp/dir
cp -r /usr/local/share/latex-mk/example /tmp/tmp/dir

You will also need to set the enviroment variable

LATEX_MK_DIR

    This should be set to the directory where the LaTeX-Mk .mk files 
    have been installed to.  This is usually something like
    /usr/local/bin/share/latex-mk

f you are using csh/tcsh:

setenv LATEX_MK_DIR /usr/local/bin/share/latex-mk

In you are using sh/bash:

LATEX_MK_DIR=/usr/local/bin/share/latex-mk
export LATEX_MK_DIR

Now go to the "running the example" section.

----------------------------------------
Running the example
----------------------------------------

The example includes two different makefiles.  One is called
"makefile.mk" which uses the BSD make syntax.  The other is
"makefile.gmk" and uses the GNU make syntax.  Normally you
would just use the name "Makefile" and use the syntax appropriate
for your version of make.  However, to provide both a GNU make
and a BSD make example, I used two different names.  You can tell
make which makefile to use via the -f flag.  So to run GNU make,
you'd do:
	gmake -f makefile.gmk
and for BSD make,
	make -f makefile.mk

Try various targets like
	make -f makefile.mk pdf
	make -f makefile.mk clean
to see what make would run with actually having it run the commands
use the -n flag like:
	make -f makefile.mk -n viewpdf


