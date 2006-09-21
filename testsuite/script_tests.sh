#!/bin/sh
#
# $Id: script_tests.sh,v 1.10 2006/09/21 14:02:52 dan Exp $
#
# Copyright (c) 2006 Dan McMahill
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#        This product includes software developed by Dan McMahill
#  4. The name of the author may not be used to endorse or promote products
#     derived from this software without specific prior written permission.
# 
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
#  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  SUCH DAMAGE.
#

regen=no
noclean=no

while test -n "$1"
do
    case "$1"
    in

    -h|--help)
	echo "Sorry, help not available for this script yet"
	exit 0
	;;

    --noclean)
	noclean=yes
	shift
	;;

    -r|--regen)
	# regenerate the 'golden' output files.  Use this with caution.
	# In particular, all differences should be noted and understood.
	regen=yes
	shift
	;;

    -*)
	echo "unknown option: $1"
	exit 1
	;;

    *)
	break
	;;

    esac
done

if [ "X$regen" = "Xyes" ]; then
    sufx="ref"
else
    sufx="log"
fi

LATEX_MK_DIR=${top_srcdir:-..}

LATEX_MK_DIR=`cd ${LATEX_MK_DIR} && pwd`
export LATEX_MK_DIR

echo "LATEX_MK_DIR = $LATEX_MK_DIR"
# printenv

# golden directory
REF=latex_mk_ref

#######################################
#
# Here we have to clean out some environment variables
# which may mess up the test results
#

BIBTEX=bibtex
BIBTEX_FLAGS=
LATEX=latex
LATEX_FLAGS=
MAKEIDX=makeindex
MAKEIDX_FLAGS=
PDFLATEX=pdflatex
PDFLATEX_FLAGS=
TEX2PAGE=tex2page
TEX2PAGE_FLAGS=

export BIBTEX
export BIBTEX_FLAGS
export LATEX
export LATEX_FLAGS
export MAKEIDX
export MAKEIDX_FLAGS
export PDFLATEX
export PDFLATEX_FLAGS
export TEX2PAGE
export TEX2PAGE_FLAGS

# these should just not be set at all
LATEX_MK_LOG=x ; unset LATEX_MK_LOG
TEXMFOUTPUT=x ; unset TEXMFOUTPUT
TEXINPUTS=x ; unset TEXINPUTS
BIBINPUTS=x ; unset BIBINPUTS

#
#
#######################################

# make sure we have the right paths when running this from inside the
# source tree and also from outside the source tree.
here=`pwd`
srcdir=${srcdir:-$here}
srcdir=`cd $srcdir && pwd`

rundir=${here}/run

if [ ! -d ${REF} ]; then
    mkdir ${REF}
fi

TESTLIST=${srcdir}/script_tests.list

if [ ! -f $TESTLIST ]; then
    echo "ERROR: ($0)  Test list $TESTLIST does not exist"
    exit 1
fi

# fail/pass/total counts
fail=0
pass=0
skip=0
tot=0

if test -z "$1" ; then
    all_tests=`awk 'BEGIN{FS="|"} /^#/{next} /^[ \t]*$/{next} {print $1}' $TESTLIST | sed 's; ;;g'`
else
    all_tests=$*
fi

echo "Starting tests in $here."
echo "Source directory is $srcdir"

echo "Syntax check on the shell scripts..."
sfail=0
spass=0
stot=0
for s in \
	${here}/../ieee-copyout \
	${here}/../latex-mk \
	${srcdir}/run_tests.sh \
	${srcdir}/script_tests.sh 
	do
	echo "Script: ${s}"
	sh -n ${s}
	rc=$?
	if test $rc -ne 0 ; then
		echo "FAILED:  return code = ${rc}"
		sfail=`expr $sfail + 1`
	else
		spass=`expr $spass + 1`
		echo "PASS"
	fi
done
stot=`expr $sfail + $spass`

echo "latex-mk script tests..."

# See if we are running as root or not.  If we are running as root we have
# to skip a few tests.  The tests in question are ones where we try to write
# to a read only directory.  root is allowed to go ahead and do this which
# throws off the tests.

for i in "${ID}" /usr/xpg4/bin/id /usr/bin/id /bin/id ; do
	if test -x "${i}" ; then
		ID="${i}"
		break
	fi
done
echo "Set ID=${ID}"

uid=`${ID} -u`
if test ${uid} -eq 0 ; then
	root_user=yes
else
	root_user=no
fi

for t in $all_tests ; do

	grep "^[ \t]*${t}[ \t]*|" $TESTLIST >/dev/null
	if test $? -ne 0 ; then
		echo "$0:  Error, specified test ${t} does not exist in ${TESTLIST}" >/dev/stderr
		exit 1
	fi
	tot=`expr $tot + 1`

	# test_name | directories to create | files needed | arguments to latex-mk | env vars
	dirs=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $2}'`
	files=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $3}'`
	args=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $4}'`
	vars=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $5}'`
	ret=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $6}' | sed 's; ;;g'`
	root=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $7}' | sed 's; ;;g'`

	if test "X${root}" = "Xno" -a "X${root_user}" = "Xyes" ; then
		echo "Skipping ${t} which will fail if run as root (and you are running as root)"
		skip=`expr $skip + 1`
		continue
	fi

	if test "X${ret}" = "X" ; then
		ret=0
	fi


	# create temporary run directory
	rm -fr ${rundir}
	mkdir -p $rundir

	# Create the subdirectories needed
	if [ ! -z "$dirs" ]; then
		for dir in $dirs ; do
			d=`echo $dir | sed 's;:.*;;g'`
			#echo "mkdir -p ${rundir}/${d}"
			mkdir -p ${rundir}/${d}
		done
	fi

	# Create the files needed
	if [ ! -z "$files" ]; then
		for f in $files ; do
			#echo "cp -f ${srcdir}/texfiles/${f} ${rundir}"
			cp -f ${srcdir}/texfiles/${f} ${rundir}
		done
	fi
    
	# Set the permissions on the subdirectories
	if [ ! -z "$dirs" ]; then
		for dir in $dirs ; do
			d=`echo $dir | sed 's;:.*;;g'`
			m=`echo $dir | awk 'BEGIN{FS=":"} {print $2}'`
			if [ "X${m}" != "X" ]; then
				#echo "chmod ${m} ${rundir}/${d}"
				chmod ${m} ${rundir}/${d}
			fi
		done
	fi

	# run the test
	echo "Test:  $t"
	testlog="/tmp/script_tests.$$$$"
	#echo "cd ${rundir} && env ${vars} ${here}/../latex-mk --testlog ${testlog} $args" 
	cd ${rundir} && env ${vars} ${here}/../latex-mk --testlog ${testlog} $args 2>&1 \
		> ${here}/${REF}/${t}.dlog 
	rc=$?

	if test $rc -ne $ret -a "X$regen" != "Xyes" ; then
		echo "FAIL due to wrong return code.  Received $rc, expected $ret"
	fi

	# take care of some absolute paths which may appear in the test log file.
	if test -f ${testlog} ; then
		sed "s;${here};HERE;g" ${testlog} > ${here}/${REF}/${t}.${sufx}
		rm ${testlog}
	else
		echo "latex-mk returned $rc" > ${here}/${REF}/${t}.${sufx}
		sed "s;${here};HERE;g" ${here}/${REF}/${t}.dlog >> ${here}/${REF}/${t}.${sufx}
	fi

	if [ "X$regen" != "Xyes" ]; then
		if [ -f ${srcdir}/${REF}/${t}.ref ]; then
			if diff -w ${srcdir}/${REF}/${t}.ref ${here}/${REF}/${t}.log >/dev/null ; then
				echo "PASS"
				pass=`expr $pass + 1`
	    		else
				echo "FAILED:  See diff -w ${srcdir}/${REF}/${t}.ref ${here}/${REF}/${t}.log"
				fail=`expr $fail + 1`
			fi
		else
			echo "No reference file.  Skipping"
			skip=`expr $skip + 1`
		fi
	else
		echo "Regenerated"
	fi

	cd $here
    
	# clean up the rundirectory
	chmod -R a+w ${rundir}
	if test "X${noclean}" != "Xyes" ; then 
		rm -fr ${rundir}
	else
		echo "Keeping run directory ${rundir}"
	fi

done

echo "LaTeX-Mk shell script syntax:  Passed $spass, failed $sfail out of $stot tests."
echo "LaTeX-Mk latex-mk script:  Passed $pass, failed $fail, skipped $skip out of $tot tests."

rc=0
if [ $spass -ne $stot ]; then
    rc=1
fi
if [ $fail -ne 0 ]; then
    rc=1
fi

exit $rc

