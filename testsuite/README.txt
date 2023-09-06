Currently, the 'run_tests.sh' script looks at the environment
variables 'BMAKE' and 'GMAKE' to figure out the name of the BSD make
and GNU make programs.  They will default to 'make' and 'gmake'
respectively.  If you do not have both of these installed on your
system, you can either use --without-bmake or --without-gmake flags to
the test script or simply ignore the error output.

The testsuite as currently implemented simply runs a 'make -n'  with
various setups to see that the correct actions would be taken.  This
hopefully provides pretty good coverage of the make rules.


The 'latex-mk' script is checked by the 'script_tests.sh' script.
The tests here rely on having a working LaTeX installation.  latex-mk
includes the ability to log its actions to a file which can then be
compared to a reference.  Hopefully the actions will not vary with 
what version of LaTeX is installed.


