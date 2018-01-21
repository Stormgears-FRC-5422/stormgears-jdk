#!/bin/bash

PKG=stormgears-jdk
PKGVER=1.8.0.1
PKGREL=161.1

. /etc/os-release
dist=$ID$VERSION_ID
codename=$VERSION_CODENAME
[ -z "$codename" ] && codename=$(echo $VERSION | sed 's/.*(\(.*\)).*/\1/')

WD=$(dirname $0)
[ "$WD" == "." ] && WD=$PWD

[ "$ID" == "ubuntu" ] && PKGSRC=jdk-8u161-linux-x64.tar.gz
[ "$ID" == "raspbian" ] && PKGSRC=jdk-8u161-linux-arm32-vfp-hflt.tar.gz

if [ ! -e "$PKGSRC" ]; then
  echo copy source package $PKGSRC to $WD
  exit 1
fi

rm -rf $WD/work
mkdir -p $WD/work/${PKG}-${PKGVER}
cp -r $WD/deb $WD/work/${PKG}-${PKGVER}/debian
cp $WD/$PKGSRC $WD/work/${PKG}-${PKGVER}/jdk.tar.gz
cp $WD/Makefile.pkg $WD/work/${PKG}-${PKGVER}/Makefile
cp $WD/profile.pkg $WD/work/${PKG}-${PKGVER}
 
cat > $WD/work/${PKG}-${PKGVER}/debian/changelog <<EOF
$PKG (${PKGVER}-${PKGREL}.$dist) $codename; urgency=medium

  * Automatically generated

 -- W. Mark Smith <wmsmith@gmail.com>  $(date -R)
EOF
tar -C work -czf work/${PKG}_${PKGVER}.orig.tar.gz ${PKG}-${PKGVER}

cat <<EOF
Source files are prepared. You have two options:
(1) Build deb package:
  cd $WD/work/${PKG}-${PKGVER} && dpkg-buildpackage -us -uc -b
(2) Prepare upload for PPA:
  cd $WD/work/${PKG}-${PKGVER} && dpkg-buildpackage -S
EOF

cd $WD

