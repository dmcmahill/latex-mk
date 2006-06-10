#!/bin/sh
#
# $Id: script_tests.sh,v 1.3 2006/06/10 13:22:44 dan Exp $
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
#
#
#######################################

# make sure we have the right paths when running this from inside the
# source tree and also from outside the source tree.
here=`echo 'echo $cwd' | csh -s`
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

for t in $all_tests ; do

	grep "^[ \t]*${t}[ \t]*|" $TESTLIST >/dev/null
	if test $? -ne 0 ; then
		echo "$0:  Error, specified test ${t} does not exist in ${TESTLIST}" >/dev/stderr
		exit 1
	fi
	# test_name | directories to create | files needed | arguments to latex-mk | env vars
	dirs=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $2}'`
	files=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $3}'`
	args=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $4}'`
	vars=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $5}'`
	ret=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $6}'`

	if test "X${ret}" = "X" ; then
		ret=0
	fi

	tot=`expr $tot + 1`

	# create temporary run directory
	if [ ! -d $rundir ]; then
		mkdir -p $rundir
	fi

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
			if diff ${srcdir}/${REF}/${t}.ref ${here}/${REF}/${t}.log >/dev/null ; then
				echo "PASS"
				pass=`expr $pass + 1`
	    		else
				echo "FAILED:  See diff ${srcdir}/${REF}/${t}.ref ${here}/${REF}/${t}.log"
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

echo "LaTeX-Mk latex-mk script:  Passed $pass, failed $fail, skipped $skip out of $tot tests."

rc=0
if [ $pass -ne $tot ]; then
    rc=1
fi

exit $rc

