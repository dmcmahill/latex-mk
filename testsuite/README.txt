# $Id: README.txt,v 1.1 2003/02/25 00:26:21 dan Exp $
#

Currently, the 'run_tests.sh' script looks at the environment
variables 'BMAKE' and 'GMAKE' to figure out the name of the BSD make
and GNU make programs.  They will default to 'make' and 'gmake'
respectively.  If you do not have both of these installed on your
system, you can either use --without-bmake or --without-gmake flags to
the test script or simply ignore the error output.

The testsuite as currently implemented simply runs a 'make -n'  with
various setups to see that the correct actions would be taken.  This
hopefully provides pretty good coverage of the make rules.  The
'latex-mk' script however is not currently covered by the testsuite.
I'd like to fix this at some point.

