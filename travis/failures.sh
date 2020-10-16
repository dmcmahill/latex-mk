#!/bin/sh
#
# This script is executed on a travis failure:

for f in config.log testsuite/test-suite.log ; do
    echo "++++ ${f}"
    if test -f "${f}" ; then
        cat "${f}"
    else
        echo "${f} Not found"
    fi
done

for tool in makeinfo texi2html ; do
    echo "+++ ${tool} check"
    which -a "${tool}" 2>&1 || true
done

echo "+++ See if makeinfo --html works"
man makeinfo

