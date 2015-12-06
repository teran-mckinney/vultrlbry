#!/bin/sh

NAME='lbrycrd'
REPO='https://github.com/lbryio/lbrycrd.git'

progress() {
	echo "$NAME: $*" > /dev/console
	echo "$NAME: $*"
}

# This runs at the top of cloud-init. We don't even have SSHD running without
# this.

export ASSUME_ALWAYS_YES=yes

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# pkg isn't installed by default on vultr, but this will bootstrap it
# with the above option of ASSUME_ALWAYS_YES=yes

progress 'Starting pkg upgrade'
pkg upgrade

progress 'Starting pkg install'
pkg upgrade
pkg install ca_root_nss autotools pkgconf gmake boost-libs openssl db48 git #FIXME TODO: Remove git
chmod 700 /root
mkdir "/root/.$NAME"
echo 'rpcuser=rpc
rpcpassword=rpcpassword' > /root/.$NAME/$NAME.conf
# ^ If the user and password are the same, it will fail.

mkdir /root/tmp

# tmpfs for speed and because / is too small otherwise.
# growfs seems to have problems, not sure why.
mount -t tmpfs tmpfs /root/tmp
cd /root/tmp
#FIXME try this some time.
#fetch -qo - /archive/$TAG.tar.gz | tar xzf -

progress 'Starting git clone'
git clone --depth 1 $REPO
cd $NAME
./autogen.sh
./configure --with-gui=no --without-miniupnpc --with-incompatible-bdb
progress 'About to compile'
gmake -j 2
gmake install
cd /
umount /root/tmp

echo "#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export HOME=/root
$NAME -daemon -noupnp > /var/log/$NAME.log 2>&1" > /etc/rc.local

echo 'ntpd_enable="YES"' >> /etc/rc.conf

chmod 500 /etc/rc.local

# Let the boot process start rc.local on its own (no reboot needed for this).
#/etc/rc.local
