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

./configure --prefix=/usr
make
sudo make install

