#!/bin/sh

bmake_prefix=${bmake_prefix:-/usr}

bmake_nm=bmake
bmake_dist=${bmake_nm}.tar.gz
bmake_url=http://www.crufty.net/ftp/pub/sjg/${bmake_dist}

do_install=yes
usage() {
    cat <<EOF

$0 - download and install BSD make (bmake)

Options

    -h|--help       : show this help message and exit

    --no-install    :  build but do not install

    --prefix prefix : specify an install prefix.  Default is ${bmake_prefix}

EOF
}

while test $# -gt 0 ; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;

        --no-install)
            do_install=no
            shift
            ;;

        --prefix)
            bmake_prefix=$2
            shift 2
            ;;

        -*)
            echo "$1 not understood"
            exit 1
            ;;

        *)
            break
            ;;
    esac
done

set -ex
if test -x /usr/bin/wget ; then
    wget ${bmake_url} -O ${bmake_dist}
else
    ftp ${bmake_url}
fi

tar -zxvf ${bmake_dist}
cd ${bmake_nm}

echo "Checking VERSION"
cat VERSION


PATCH_DIR=../travis
PATCH_FILE_BASE=bmake-patch
if ls ${PATCH_DIR}/${PATCH_FILE_BASE}* 2>/dev/null ; then
    echo "Applying local patches"
    for f in `find ${PATCH_DIR}/ -name ${PATCH_FILE_BASE}\* -print` ; do
        echo "Apply $f"
        patch -p0 < $f
    done
fi

cat << EOF

prefix           : ${prefix}
PREFIX           : ${PREFIX}
DEFAULT_SYS_PATH : ${DEFAULT_SYS_PATH}

EOF

./configure --prefix=${bmake_prefix}
make prefix=${bmake_prefix} DEFAULT_SYS_PATH=${bmake_prefix}/share/mk

if test $do_install = yes ; then
    sudo make install

    echo "Running basic sanity check for functionality"

    cat > tmp.mk <<EOF
# include some of the "." commands that we need from a 
# BSD make.
MYVAR= BSDmake
MYFLAG= #defined
test:
.for __tmp__ in \${MYVAR}
.if defined(MYFLAG)
	@echo \${__tmp__}
.endif
.endfor
EOF

    echo "========= tmp.mk =========="
    cat tmp.mk
    echo "========= ====== =========="

    ${bmake_prefix}/bin/bmake -f tmp.mk

fi

