#!/bin/sh

#bmake_ver=4.2.5
bmake_nm=bmake
bmake_dist=${bmake_nm}.tar.gz

set -ex
wget http://www.crufty.net/ftp/pub/sjg/${bmake_dist} -O ${bmake_dist}
tar -zxvf ${bmake_dist}
cd ${bmake_nm}

for f in `find ../travis/ -name bmake-patch\* -print` ; do
    echo "Apply $f"
    patch -p0 < $f
done

cat << EOF

prefix           : ${prefix}
PREFIX           : ${PREFIX}
DEFAULT_SYS_PATH : ${DEFAULT_SYS_PATH}

EOF

./configure --prefix=/usr 
make prefix=/usr DEFAULT_SYS_PATH=/usr/share/mk
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

/usr/bin/bmake -f tmp.mk

