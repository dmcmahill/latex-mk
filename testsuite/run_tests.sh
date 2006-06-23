#!/bin/sh
#
# $Id: run_tests.sh,v 1.24 2006/06/23 13:09:27 dan Exp $
#
# Copyright (c) 2003, 2004, 2005, 2006 Dan McMahill
# All rights reserved.
#
# This code is derived from software written by Dan McMahill
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
with_bmake=yes
with_gmake=yes

while test -n "$1"
do
    case "$1"
    in

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
CONVERT=convert
DVIPDFM=dvipdfm
DVIPDFM_ENV=
DVIPDFM_FLAGS=
DVIPS=dvips
DVIPS_FLAGS=
ECHO=echo
ENV_PROG=env
FALSE=false
GZCAT=gzcat
GZIP=gzip
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
LATEX2RTF=latex2rtf
LATEX2RTF_ENV=
LATEX2RTF_FLAGS=
LGRIND=lgrind
LGRIND_FLAGS=-i
LPR=lpr
LPR_FLAGS=
MAKEIDX=makeindex
MAKEIDX_FLAGS=
PDFLATEX=pdflatex
PDFLATEX_ENV=
PDFLATEX_FLAGS=
PS2PDF=ps2pdf
PS2PDF_FLAGS=
TAR=tar
XDVI=xdvi
XDVI_FLAGS=
VIEWPDF=acroread
VIEWPDF_FLAGS=

export BIBTEX
export CONVERT
export DVIPDFM
export DVIPDFM_ENV
export DVIPDFM_FLAGS
export DVIPS
export DVIPS_FLAGS
export ECHO
export ENV_PROG
export FALSE
export GV
export GV_FLAGS
export GZCAT
export GZIP
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
export LATEX2RTF
export LATEX2RTF_ENV
export LATEX2RTF_FLAGS
export LGRIND
export LGRIND_FLAGS
export LPR
export LPR_FLAGS
export MAKEIDX
export MAKEIDX_FLAGS
export PDFLATEX
export PDFLATEX_ENV
export PDFLATEX_FLAGS
export PS2PDF
export PS2PDF_FLAGS
export TAR
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
TGIF_FLAGS="-color -print"
TGIF_EPS_FLAGS="-eps"
TGIF_PDF_FLAGS="-pdf"

export TGIF
export TGIF_FLAGS
export TGIF_EPS_FLAGS
export TGIF_PDF_FLAGS

#######################################
# 
# xfig stuff
#
#######################################

FIG2DEV=fig2dev
FIG2DEV_FLAGS=""
FIG2DEV_EPS_FLAGS="-L eps"
FIG2DEV_PDF_FLAGS="-L pdf"

export FIG2DEV
export FIG2DEV_FLAGS
export FIG2DEV_EPS_FLAGS
export FIG2DEV_PDF_FLAGS

#######################################
#
# Make stuff
#
#######################################

BMAKE=${BMAKE:-make}
BMAKE_NAME=`basename $BMAKE`
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
export MAKEFLAGS
export MAKELEVEL
export MFLAGS

MAKECONF="/dev/null"
USER_MAKECONF="/dev/null"

export MAKECONF
export USER_MAKECONF

#######################################
#
# System stuff
#
#######################################

AWK=awk
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
MFLAGS="LATEX_MK_DIR=${LATEX_MK_DIR}"
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

for t in $all_tests ; do

    noexec_mode=yes
    case "$t" in
	\**)
	    t=`echo $t | sed 's;^\*;;g'`
	    rt="\*${t}"
	    noexec_mode=no
	    ;;
	*)
	    rt="${t}"
	    ;;
    esac
    t=`echo $t | sed 's;^\*;;g'`

    dirs=`grep "^[ \t]*${rt}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $2}'`
    files=`grep "^[ \t]*${rt}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $3}'`
    args=`grep "^[ \t]*${rt}[ \t]*|" $TESTLIST | awk 'BEGIN{FS="|"} {print $4}'`
    if [ "$noexec_mode" = "yes" ] ; then
	args="-n $args"
    fi

    tot=`expr $tot + 1`

    # create temporary run directory
    if [ ! -d $rundir ]; then
	mkdir -p $rundir
    fi

    # Create the subdirectories needed
    if [ ! -z "$dirs" ]; then
	for dir in $dirs ; do
	    mkdir -p ${rundir}/${dir}
	done
    fi

    # Create the files needed
    if [ ! -z "$files" ]; then
	copy_mode=no
	for f in $files ; do
	    case "$f" in
		@) 
		sleep 2
		;;
		
		"<" )
		    copy="cp"
		    copy_mode=yes
		    ;;
		
		">")
		    eval $copy
		    copy_mode=no
		    ;;
		
		*)
		    if [ "$copy_mode" = "yes" ]; then
			f=`echo $f | sed -e "s;@S@;${srcdir};g" -e "s;@R@;${rundir};g"`
			copy="$copy $f"
		    else
			touch ${rundir}/${f}
		    fi
		    ;;
	    esac
	done
	if [ "$copy_mode" = "yes" ]; then
	    echo "ERROR:  copy_mode is still yes for test ${t}"
	    echo "        This indicates a bug in tests.list"
	    echo " "
	    exit 1
	fi
    fi
    
    # run the BSD make test
    #
    # normalize messages like:
    # make: stopped in /export/disk1/src/local-cvs/localsrc/misc/latex-mk/testsuite/run/dir1
    # to avoid developer paths
    if [ "X$with_bmake" = "Xyes" ]; then
    echo "Test:  (BSD make) $t"
    cd ${rundir} && ${BMAKE}  $args | sed \
	-e "s;stopped in .*/testsuite/run/;stopped in testsuite/run/;g" \
	-e "s;${BMAKE_NAME};make;g" \
	> ${here}/${BMAKE_REF}/${t}.${sufx}
    if [ "X$regen" != "Xyes" ]; then
	if [ -f ${srcdir}/${BMAKE_REF}/${t}.ref ]; then
	    if diff -w ${srcdir}/${BMAKE_REF}/${t}.ref ${here}/${BMAKE_REF}/${t}.log >/dev/null ; then
		echo "PASS"
		bpass=`expr $bpass + 1`
	    else
		echo "FAILED:  See diff -w ${srcdir}/${BMAKE_REF}/${t}.ref ${here}/${BMAKE_REF}/${t}.log"
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
    # I use 'gmake' on my system
    #
    # Also, we have to watch out for the gmake entering/leaving directory messages.
    # those will have the full system path so we have to normalize it here
    cd ${rundir} && ${GMAKE}  $args | sed -e "s;${GMAKE_NAME};gmake;g" \
	-e "s;directory .*/testsuite/run/;directory \`testsuite/run/;g" \
	> ${here}/${GMAKE_REF}/${t}.${sufx}
    if [ "X$regen" != "Xyes" ]; then
	if [ -f ${srcdir}/${GMAKE_REF}/${t}.ref ]; then
	    if diff -w ${srcdir}/${GMAKE_REF}/${t}.ref ${here}/${GMAKE_REF}/${t}.log >/dev/null ; then
		echo "PASS"
		gpass=`expr $gpass + 1`
	    else
		echo "FAILED:  See diff -w ${srcdir}/${GMAKE_REF}/${t}.ref ${here}/${GMAKE_REF}/${t}.log"
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
if [ $bpass -ne $tot  -a "X$with_bmake" = "Xyes" ]; then
    rc=1
fi
if [ $gpass -ne $tot  -a "X$with_gmake" = "Xyes" ]; then
    rc=1
fi

exit $rc
