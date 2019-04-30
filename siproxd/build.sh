#/bin/sh

LIBOSIP="libosip2-5.1.0"
LIBOSIP_URL="http://ftp.gnu.org/gnu/osip/${LIBOSIP}.tar.gz"
SIPROXD="siproxd-0.8.2"
SIPROXD_URL="https://downloads.sourceforge.net/project/siproxd/siproxd/0.8.2/siproxd-0.8.2.tar.gz"

wget "$LIBOSIP_URL"
tar xzvf $LIBOSIP.tar.gz
cd $LIBOSIP
./configure
make
make install

cd ..

wget $SIPROXD_URL
tar xzvf $SIPROXD.tar.gz
cd $SIPROXD
patch -p0 < /tmp/build/siproxd-001.patch 
patch -p0 < /tmp/build/siproxd-002.patch 

./configure --with-ltdl-fix
make
make install
