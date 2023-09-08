#!/bin/sh
#
# Copyright (c) 2006-2023 Dan McMahill
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#


regen=no
noclean=no

usage() {
cat <<EOF

$0 -- Run automated tests on the scripts which are part of the
      LaTeX-Mk package.

USAGE:

$0 -h|--help
$0 [options] [tests]

OPTIONS:

-h|--help      Display this help message and exit

--noclean      After running the test, do not remove the run directory
               or the files contained there.  This is useful for debugging
               a failure.

-r|--regen     Regenerate the 'golden' reference files.  This option needs
               to be used with caution.  Any changes to the golden files
               need to be verified by hand.


EOF
}
while test -n "$1"
do
    case "$1"
    in

    -h|--help)
	usage
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

LATEX_MK_DIR=`cd ${LATEX_MK_DIR} && echo $PWD`
export LATEX_MK_DIR

echo "LATEX_MK_DIR = $LATEX_MK_DIR"
# printenv

# golden directory
REF=latex_mk_ref

tmpdir=${TMPDIR:-/tmp}/latex-mk.$$
mkdir -m 0700 -p ${tmpdir}
rc=$?
if test $rc -ne 0 ; then
	echo "Failed to create temp directory ${tmpdir}"
	exit 1
fi

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
here=${PWD}
here=`cd $here && echo $PWD`
srcdir=${srcdir:-$here}
srcdir=`cd $srcdir && echo $PWD`

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
		# this horrible ugly hack is supposed to deal with allowing file names that have
		# spaces in them.  Surely there is a better way but it eludes me at the moment.
		cat > ${tmpdir}/files << EOF
		for f in ${files} ; do 
			#echo "f = \"\${f}\""
			echo "cp -f \"${srcdir}/texfiles/\${f}\" ${rundir}"
			cp -f "${srcdir}/texfiles/\${f}" ${rundir}
done
EOF
		#cat ${tmpdir}/files
		. ${tmpdir}/files
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
	# We redirect from /dev/null because if the latex installation isn't quite
	# right we may end up with latex waiting for input from stdin but we don't
	# ever want to do that.  This is especially important since we are redirecting
	# stdout and stderr so the user won't even see whats going on.
	cat > ${tmpdir}/run << EOF
	cd ${rundir} && env ${vars} ${here}/../latex-mk --testlog ${testlog} $args 2>&1 \
		> ${here}/${REF}/${t}.dlog  < /dev/null
	rc=\$?
EOF
	cat ${tmpdir}/run
	. ${tmpdir}/run
	if test $rc -ne $ret -a "X$regen" != "Xyes" ; then
		echo "FAIL due to wrong return code.  Received $rc, expected $ret"
	fi

	# take care of some absolute paths which may appear in the test log file.
	if test -f ${testlog} ; then
		sed -e "s;${here};HERE;g" -e "s;current directory:.*run;current directory: HERE/run;g" \
			${testlog} > ${here}/${REF}/${t}.${sufx}
		rm ${testlog}
	else
		echo "latex-mk returned $rc" > ${here}/${REF}/${t}.${sufx}
		sed -e "s;${here};HERE;g" -e "s;current directory:.*run;current directory: HERE/run;g" \
			${here}/${REF}/${t}.dlog >> ${here}/${REF}/${t}.${sufx}
	fi

	if [ "X$regen" != "Xyes" ]; then
		if [ -f ${srcdir}/${REF}/${t}.ref ]; then
            _psed='/^@debug:/d'

            _f1="${srcdir}/${REF}/${t}.ref"
            _f1p="${here}/${REF}/${t}-processed.ref"
            sed "${_psed}" "${_f1}" > "${_f1p}"

            _f2="${here}/${REF}/${t}.log"
            _f2p="${here}/${REF}/${t}-processed.log"
            sed "${_psed}" "${_f2}" > "${_f2p}"

			if diff -w "${_f1p}" "${_f2p}" >/dev/null ; then
				echo "PASS"
				pass=`expr $pass + 1`
	    		else
				echo "FAILED:  See diff -w ${_f1p} ${_f2p}"
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

rm -fr ${tmpdir}
exit $rc

