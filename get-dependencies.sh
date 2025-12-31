#!/bin/sh

set -eux

ARCH=$(uname -m)

VERSION="$(sed -n 1p version.txt)"
URL_PEAZIP_QT="$(sed -n 2p version.txt)"
#URL_PEAZIP_GTK="$(sed -n 3p version.txt)"
URL_SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

echo "Downloading scripts..."
echo "----------------------"

dnf in -y wget

FILENAME=$(basename "${URL_SHARUN:7}")
if ! [ -f $FILENAME ]
then
	wget "$URL_SHARUN" -O "$FILENAME"
	chmod +x "$FILENAME"
fi

TARFILE_QT=$(basename "${URL_PEAZIP_QT:7}")
if ! [ -f $TARFILE_QT ]
then
	wget "$URL_PEAZIP_QT" -O "$TARFILE_QT"
fi

#TARFILE_GTK=$(basename "${URL_PEAZIP_GTK:7}")
#wget "$URL_PEAZIP_GTK" -O "$TARFILE_GTK"

echo "Installing dependencies..."
echo "--------------------------"

if [ "$VERSION" == "10.8.0" ]
then

	mkdir -vp extracted

	tar -xvf "$TARFILE_QT" -C extracted
	EXTRACTED="extracted/""$(ls extracted/|sed -n 1p)"
	mv -v "$EXTRACTED" peazip-qt
	rmdir extracted

	#tar -xvf "$TARFILE_GTK" -C extracted
	#EXTRACTED="extracted/""$(ls extracted/|sed -n 1p)"
	#mv -v "$EXTRACTED" peazip-gtk
	#rmdir extracted

	dnf in -y xorg-x11-server-Xvfb patchelf zstd libX11 gdk-pixbuf2 fontconfig libXrender libXinerama fastfetch zsync strace binutils
	dnf in -y qt6-qtbase qt6-qtbase-gui systemd-libs
	# dnf in -y gtk2 cairo pango
fi
