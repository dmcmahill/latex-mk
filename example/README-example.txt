# $Id: README-example.txt,v 1.1 2002/10/08 13:45:06 dan Exp $
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

----------------------------------------
Trying the example after installation
----------------------------------------

If you wish to try out the example after installation, you will need to
copy the examples directory to a working directory where you have write
permissions.  Assuming that the examples directory was installed to
/usr/local/share/latex-mk/example, you can do something like:

mkdir /some/tmp/dir
cp -r /usr/local/share/latex-mk/example /tmp/tmp/dir


