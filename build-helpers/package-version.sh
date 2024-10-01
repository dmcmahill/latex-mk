#!/bin/sh
#
#   $0 <path-to-top_srcdir> <version-stamp-file>
#
# <path-to-top_srcdir> may be relative
#
# <version-stamp-file> is relative to src/build topdir
#
# based on https://github.com/ndim/ndim-utils/blob/main/build-helpers/package-version

GIT=${GIT:-git}
SED=${SED:-sed}
TR=${TR:-tr}}

top_srcdir="${1-.}"
test -d "$top_srcdir" || { \
	echo "Could not change to top_srcdir '$1'" >&2; \
	exit 1; \
}
version_stamp="${2-version-stamp}"

# If GIT_DIR is set, use it. If not, try top_srcdir/.git.
if test -n "$GIT_DIR"; then :;
else GIT_DIR="$top_srcdir/.git"; export GIT_DIR
fi

# '\012' is a newline
if test -f "$top_srcdir/$version_stamp"; then # dist source tree
	cat "$top_srcdir/$version_stamp" | ${TR} -d '\012'
elif test -d "$GIT_DIR"; then # git source tree
	git_describe=`${GIT} describe 2>/dev/null || echo devel`
	# change tags like "foo-conf-1.2" to "1.2"
	echo "$git_describe" | ${SED-sed} 's/^\([A-Za-z0-9_-]\{1,\}\)-\([0-9]\)/\2/;s/-/./;s/-g/-/' | ${TR} -d '\012'
else # ???
	echo "rdevel" | ${TR} -d '\012'
fi

