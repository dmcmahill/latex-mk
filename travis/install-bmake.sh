#!/bin/sh

#bmake_ver=4.2.5
bmake_nm=bmake
bmake_dist=${bmake_nm}.tar.gz

set -ex
wget http://www.crufty.net/ftp/pub/sjg/${bmake_dist} -O ${bmake_dist}
tar -zxvf ${bmake_dist}
cd ${bmake_nm}
./configure --prefix=/usr
make
sudo make install

