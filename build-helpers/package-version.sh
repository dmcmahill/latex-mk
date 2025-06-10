#!/bin/sh
#
#   $0 <path-to-top_srcdir> <version-stamp-file>
#
# <path-to-top_srcdir> may be relative
#
# <version-stamp-file> is relative to src/build topdir
#
# based on https://github.com/ndim/ndim-utils/blob/main/build-helpers/package-version

AWK=${AWK:-awk}
GIT=${GIT:-git}
SED=${SED:-sed}
TR=${TR:-tr}

prog="$(basename "$0")"
prog_full="$0"
usage() {
    cat << EOF

${prog} - report package version string

Usage:

${prog} [options] [top_srcdir [version_stamp]]

Options:

    --debug        : Enable verbose output

    --help         : Show this help message an exit

    --test-all     : Run all test cases

    --testcase <n> : Run with the specified test case number

Positional Arguments:
  top_srcdir       : Path to the top of the source tree.  Defaults to the current directory.

  version_stamp    : Path to the version stamp file that contains the version in source
                     archives (i.e. not a git checkout)

EOF
}

testcase=none
_verbose=no

verbose() {
    if [ "${_verbose}" = "yes" ] ; then
        return 0
    else
        return 1
    fi
}

report_tests() {
    if [ "${_report_tests}" = "yes" ] ; then
        return 0
    else
        return 1
    fi
}

test_all() {
    for tag in vtag1 vtag2 devtag1 devtag2 fail1 fail2 ; do
        printf "\n--- TESTCASE %s ---\n" "${tag}"
        "${prog_full}"  --testcase "${tag}"
        printf "\n\n"
    done
}

while [ $# -gt 0 ] ; do
    case $1 in
        --debug)
            _verbose=yes
            shift
            ;;

        --help)
            usage
            exit 0
            ;;

        --test-all)
            test_all
            exit 0
            ;;

        --testcase)
            testcase=$2
            shift 2
            ;;

        -*)
            echo "${prog}:  ERROR:  $1 is not a valid option"
            exit 1
            ;;

        *)
            break
            ;;
    esac
done

top_srcdir="${1-.}"
if ! test -d "${top_srcdir}" ; then
	echo "Missing top_srcdir '${top_srcdir}' directory" >&2
	exit 1
fi

version_stamp="${2-version-stamp}"

# If GIT_DIR is set, use it. If not, try top_srcdir/.git.
if ! test -n "$GIT_DIR" ; then
    GIT_DIR="${top_srcdir}/.git"
    export GIT_DIR
fi

# '\012' is a newline
if test -f "${top_srcdir}/${version_stamp}"; then
    #
    # This is a distribution source tree (e.g. from a release tar file)
    #
    if verbose ; then
        echo "${prog}:  Found stamp file ${top_srcdir}/${version_stamp}" >&2
    fi
    
	${TR} -d '\012' < "${top_srcdir}/${version_stamp}"

elif test -d "$GIT_DIR"; then
    #
    # We are in a git source tree so look for tags
    #
    if verbose ; then
        echo "${prog}:  Found GIT_DIR=${GIT_DIR}" >&2
    fi

    # See if there is an annotated release tag (like v1.2.3)
    # or annotated tag that is used to indicate a major or minor
    # version bump (as opposed to the assumed patch version bump if
    # we have additional commits on top of a release tag.
    _report_tests=yes
    case ${testcase} in
        none)
            r=0
            rslt="$(${GIT} describe --match 'v*' --match 'dev*' --dirty 2>/dev/null)"
            r=$?
            _report_tests=no
            ;;

        devtag1)
            r=0
            rslt="dev1.2.3"
            ;;

        devtag2)
            r=0
            rslt="dev2.1.0-15-dirty"
            ;;

        vtag1)
            r=0
            rslt="v1.2.3"
            ;;

        vtag2)
            r=0
            rslt="v2.1.0-15-dirty"
            ;;

        fail1)
            r=128
            rslt="bad-result"
            ;;

        fail2)
            r=0
            rslt="bad-result"
            ;;

        *)
            r=128
            rslt=""
            ;;
    esac
    if report_tests ; then
        echo "${prog}:  Testcase with r=${r} and rslt=${rslt}"
    fi
    if verbose ; then
        echo "After checking for annotated tags, r=${r}, rslt=${rslt}" >&2
    fi
    if [ ${r} -eq 0 ] ; then
        case ${rslt} in
            dev*)
                # these tags are used to indicate a major or minor bump has happened and so we don't need to explicitly bump the patch rev
                # shellcheck disable=SC2016
                ver=$(echo "${rslt}" | ${AWK} -F '[v.-]' '{maj=$2; min=$3; patch=$4; sfx="pre"; for(i=5; i<=NF; i++) {sfx = sfx "-" $i;} printf("%d.%d.%d%s", maj, min, patch, sfx);}')
                if verbose ; then echo "${prog}:  Converted dev tag ${rslt} to version ${ver}" >&2 ; fi
                ;;
            v*)
                # assume we will bump the patch rev
                # shellcheck disable=SC2016
                ver=$(echo "${rslt}" | ${AWK} -F '[v.-]' '{maj=$2; min=$3; patch=$4; sfx=""; if(NF >=5) {sfx = sfx "pre"; inc = 1} ; for(i=5; i<=NF; i++) {sfx = sfx "-" $i;} printf("%d.%d.%d%s", maj, min, patch+inc, sfx);}')
                if verbose ; then echo "${prog}:  Converted release tag ${rslt} to version ${ver}" >&2 ; fi
                ;;
            *)
                echo "${prog}:  ERROR:  Not sure how to handle rslt=${rslt}" >&2
                exit 1
                ;;
        esac
        printf "%s" "${ver}"
        exit 0
    else
        printf "unknown-no-tags"
        echo "${prog}:  ERROR:  Unable to find annotated tag via ${GIT} describe" >&2
        exit 1
    fi


else
    #
    # We shouldn't get here unless something has become corrupted or deleted.
    #
	printf "rdevel"
fi

