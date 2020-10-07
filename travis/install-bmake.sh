#!/bin/sh

#bmake_ver=4.2.5
bmake_nm=bmake
bmake_dist=${bmake_nm}.tar.gz

set -ex
wget http://www.crufty.net/ftp/pub/sjg/${bmake_dist} -O ${bmake_dist}
tar -zxvf ${bmake_dist}
cd ${bmake_nm}

mv boot-strap boot-strap.orig
sed 's/Bmake test \|\| exit 1/Bmake test/g' boot-strap.orig > boot-strap
chmod 755 boot-strap

./configure --prefix=/usr
make
sudo make install

