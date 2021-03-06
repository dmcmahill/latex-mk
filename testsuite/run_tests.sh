#!/bin/sh
#
# Copyright (c) 2003, 2020 Dan McMahill
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
with_bmake=yes
with_gmake=yes
verbose=no

show_diff=${SHOW_DIFF:-no}
DIFF_FLAGS=${DIFF_FLAGS:-}

while test -n "$1"
do
    case "$1"
    in

    --diff-flag)
        # add to the diff flags
        DIFF_FLAGS="${DIFF_FLAGS} $2"
        shift 2
        ;;

    -h|--help)
	echo "Sorry, help not available for this script yet"
	exit 0
	;;

    -r|--regen)
	# regenerate the 'golden' output files.  Use this with caution.
	# In particular, all differences should be noted and understood.
	regen=yes
	shift
	;;

    --show-diff)
        # on failures, show the diff output
        show_diff=yes
        shift
        ;;

    --verbose)
        verbose=yes
        shift
        ;;


    --with-bmake)
	BMAKE=$2
	shift 2
	;;

    --with-gmake)
	GMAKE=$2
	shift 2
	;;

    --without-bmake)
	# don't run the BSD make tests
	with_bmake=no
	shift
	;;

    --without-gmake)
	# don't run the GNU make tests
	with_gmake=no
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
# sometimes make versions change whitespace
DIFF_FLAGS="${DIFF_FLAGS} -b"

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

#######################################
# 
# general latex stuff
#
#######################################

BIBTEX=bibtex
DVIPDFM=dvipdfm
DVIPDFM_FLAGS=
DVIPS=dvips
DVIPS_FLAGS=
ECHO=echo
ENV_PROG=env
FALSE=false
GV=gv
GV_FLAGS=
HACHA=hacha
HACHA_ENV=
HACHA_FLAGS=
HEVEA=hevea
HEVEA_ENV=
HEVEA_FLAGS=
IMAGEN=imagen
IMAGEN_ENV=
IMAGEN_FLAGS=
LATEX_MK=latex-mk
LATEX_MK_FLAGS=
LATEX=latex
LATEX_ENV=
LATEX2HTML=latex2html
LATEX2HTML_ENV=
LATEX2HTML_FLAGS=
LPR=lpr
LPR_FLAGS=
PDFLATEX=pdflatex
PDFLATEX_ENV=
PDFLATEX_FLAGS=
PS2PDF=ps2pdf
PS2PDF_FLAGS=
XDVI=xdvi
XDVI_FLAGS=
VIEWPDF=acroread
VIEWPDF_FLAGS=

export BIBTEX
export DVIPDFM
export DVIPDFM_FLAGS
export DVIPS
export DVIPS_FLAGS
export ECHO
export ENV_PROG
export FALSE
export GV
export GV_FLAGS
export HACHA
export HACHA_ENV
export HACHA_FLAGS
export HEVEA
export HEVEA_ENV
export HEVEA_FLAGS
export IMAGEN
export IMAGEN_ENV
export IMAGEN_FLAGS
export LATEX_MK
export LATEX_MK_FLAGS
export LATEX
export LATEX_ENV
export LATEX_FLAGS
export LATEX2HTML
export LATEX2HTML_ENV
export LATEX2HTML_FLAGS
export LPR
export LPR_FLAGS
export PDFLATEX
export PDFLATEX_ENV
export PDFLATEX_FLAGS
export PS2PDF
export PS2PDF_FLAGS
export XDVI
export XDVI_FLAGS
export VIEWPDF
export VIEWPDF_FLAGS

#######################################
# 
# tgif stuff
#
#######################################

TGIF=tgif
TGIF_FLAGS="-color -print -eps"

export TGIF
export TGIF_FLAGS

#######################################
# 
# xfig stuff
#
#######################################

FIG2DEV=fig2dev
FIG2DEV_FLAGS="-L eps"

export FIG2DEV
export FIG2DEV_FLAGS

#######################################
#
# Make stuff
#
#######################################

BMAKE=${BMAKE:-make}
GMAKE=${GMAKE:-gmake}
GMAKE_NAME=`basename $GMAKE`

if test "X$BMAKE" = "Xnone" ; then
    with_bmake=no
fi
if test "X$GMAKE" = "Xnone" ; then
    with_gmake=no
fi

# golden directories
BMAKE_REF=bmake_ref
GMAKE_REF=gmake_ref

# clear out some environment variables
# which may be polluting the test
MAKEFLAGS=""
MAKELEVEL=""
MFLAGS=""
USER_MAKECONF="/dev/null"

export MAKEFLAGS
export MAKELEVEL
export MFLAGS
export USER_MAKECONF

#######################################
#
# System stuff
#
#######################################

BUILD_AWK=${AWK:-awk}
AWK=awk
DIFF=${DIFF:-diff}
FIND=find
GREP=grep
RM=rm
RMDIR=rm

export AWK
export FIND
export GREP
export RM
export RMDIR

#######################################
#
#
#
#######################################
BMKF=testfile.mk
GMKF=testfile.gmk
MFLAGS="LATEX_MK_DIR=${LATEX_MK_DIR} -n"
BMAKE="${BMAKE} -f ../${BMKF} ${MFLAGS}"
GMAKE="${GMAKE} -f ../${GMKF} ${MFLAGS}"
# echo "BSD make command = $BMAKE"
# echo "GNU make command = $GMAKE"

# make sure we have the right paths when running this from inside the
# source tree and also from outside the source tree.
here=`pwd`
srcdir=${srcdir:-$here}
srcdir=`cd $srcdir && pwd`

rundir=${here}/run

SORT_SECTIONS="${BUILD_AWK} -f ${srcdir}/sort_sections.awk"

if [ ! -d ${BMAKE_REF} ]; then
    mkdir ${BMAKE_REF}
fi
if [ ! -d ${GMAKE_REF} ]; then
    mkdir ${GMAKE_REF}
fi

TESTLIST=${srcdir}/tests.list

if [ ! -f $TESTLIST ]; then
    echo "ERROR: ($0)  Test list $TESTLIST does not exist"
    exit 1
fi

# fail/pass/total counts
bfail=0
gfail=0
bpass=0
gpass=0
bskip=0
gskip=0
tot=0

if test -z "$1" ; then
    all_tests=`awk 'BEGIN{FS="|"} /^#/{next} {print $1}' $TESTLIST | sed 's; ;;g'`
else
    all_tests=$*
fi

echo "Starting tests in $here."
echo "Source directory is $srcdir"

check_verbose() {
    if test $verbose = yes ; then
        return 0
    else
        return 1
    fi
}

echo_verbose() {
    if check_verbose ; then
        echo "===> $*"
    fi
}

for t in $all_tests ; do

    dirs=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $2}'`
    files=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $3}'`
    args=`grep "^[ \t]*${t}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $4}'`

    tot=`expr $tot + 1`

    # create temporary run directory
    if [ ! -d $rundir ]; then
        echo_verbose "mkdir -p $rundir"
	mkdir -p $rundir
    fi

    # Create the subdirectories needed
    if [ ! -z "$dirs" ]; then
	for dir in $dirs ; do
	    echo_verbose "mkdir -p ${rundir}/${dir}"
	    mkdir -p ${rundir}/${dir}
	done
    fi

    # Create the files needed
    if [ ! -z "$files" ]; then
	for f in $files ; do
	    if [ "$f" = "@" ]; then
		echo_verbose "sleep 2"
		sleep 2
	    else
		echo_verbose "touch ${rundir}/${f}"
		touch ${rundir}/${f}
	    fi
	done
    fi
 
    # run the BSD make test
    if [ "X$with_bmake" = "Xyes" ]; then
    echo "Test:  (BSD make) $t"
    echo_verbose "cd ${rundir} && ${BMAKE}  $args | ${SORT_SECTIONS} > ${here}/${BMAKE_REF}/${t}.${sufx}"
    cd ${rundir} && ${BMAKE}  $args | ${SORT_SECTIONS} > ${here}/${BMAKE_REF}/${t}.${sufx}
    if [ "X$regen" != "Xyes" ]; then
	if [ -f ${srcdir}/${BMAKE_REF}/${t}.ref ]; then
	    if ${DIFF} ${DIFF_FLAGS} ${srcdir}/${BMAKE_REF}/${t}.ref ${here}/${BMAKE_REF}/${t}.log >/dev/null ; then
		echo "PASS"
		bpass=`expr $bpass + 1`
	    else
		echo "FAILED:  See ${DIFF} ${here}/${BMAKE_REF}/${t}.ref ${here}/${BMAKE_REF}/${t}.log"
                if [ "X${show_diff}" = "Xyes" ] ; then
                    ${DIFF} ${DIFF_FLAGS} ${srcdir}/${BMAKE_REF}/${t}.ref ${here}/${BMAKE_REF}/${t}.log
                fi
		bfail=`expr $bfail + 1`
	    fi
	else
	    echo "No reference file.  Skipping"
	    bskip=`expr $bskip + 1`
	fi
    else
	echo "Regenerated"
    fi
    fi

    # run the GNU make test
    if [ "X$with_gmake" = "Xyes" ]; then
    echo "Test:  (GNU make) $t"
    # we have to replace the actual name of the GNU make program with 'gmake' because
    # some of the tests will contain the name of GNU make in the output.  This way if
    # someone has installed GNU make as 'gnumake', the test will still pass even though
    # I use 'gmake' on my system.  In addition, a change happened in GNU make at some point
    # that changed output like:
    #    gmake: `test1.dvi' is up to date.
    # to
    #    gmake: 'test1.dvi' is up to date.
    #
    cd ${rundir} && ${GMAKE}  $args | \
        sed \
            -e "s;${GMAKE_NAME};gmake;g" \
            -e "/^gmake:/ s/\`/\'/g" \
        | ${SORT_SECTIONS} \
            > ${here}/${GMAKE_REF}/${t}.${sufx}
    if [ "X$regen" != "Xyes" ]; then
	if [ -f ${srcdir}/${GMAKE_REF}/${t}.ref ]; then
	    if ${DIFF} ${DIFF_FLAGS} ${srcdir}/${GMAKE_REF}/${t}.ref ${here}/${GMAKE_REF}/${t}.log >/dev/null ; then
		echo "PASS"
		gpass=`expr $gpass + 1`
	    else
		echo "FAILED:  See ${DIFF} ${here}/${GMAKE_REF}/${t}.ref ${here}/${GMAKE_REF}/${t}.log"
                if [ "X${show_diff}" = "Xyes" ] ; then
                    ${DIFF} ${DIFF_FLAGS} ${srcdir}/${GMAKE_REF}/${t}.ref ${here}/${GMAKE_REF}/${t}.log
                fi
		gfail=`expr $gfail + 1`
	    fi
	else
	    echo "No reference file.  Skipping"
	    gskip=`expr $gskip + 1`
	fi
    else
	echo "Regenerated"
    fi
    fi

    cd $here
    
    # clean up the rundirectory
    rm -fr ${rundir}

done

echo "BSD make version:  Passed $bpass, failed $bfail, skipped $bskip out of $tot tests."
echo "GNU make version:  Passed $gpass, failed $gfail, skipped $gskip out of $tot tests."

rc=0
if [ $bpass -ne $tot  -o $gpass -ne $tot ]; then
    rc=1
fi

exit $rc
