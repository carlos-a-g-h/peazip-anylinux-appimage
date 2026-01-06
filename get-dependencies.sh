#!/bin/sh

set -eux

ARCH=$(uname -m)

VERSION="$(sed -n 1p sources.txt)"
URL_PEAZIP_QT=$(awk "/peazip_portable/ && /QT/ && /$VERSION/ && /$ARCH/" sources.txt)
URL_PEAZIP_GTK=$(awk "/peazip_portable/ && /GTK/ && /$VERSION/ && /$ARCH/" sources.txt)

URL_SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

MAKE_QT=0
if ! [ -z "$URL_PEAZIP_QT" ]
then
	MAKE_QT=1
fi
MAKE_GTK=0
if ! [ -z "$URL_PEAZIP_GTK" ]
then
	MAKE_GTK=1
fi

if [ $MAKE_QT -eq 0 ] && [ $MAKE_GTK -eq 0 ]
then
	echo "Nothing to do...?"
	exit 1
fi 

echo "Downloading scripts..."
echo "----------------------"

dnf update -y

dnf in -y wget

FILENAME=$(basename "${URL_SHARUN:7}")
if ! [ -f $FILENAME ]
then
	wget "$URL_SHARUN" -O "$FILENAME"
	chmod +x "$FILENAME"
fi

if [ $MAKE_QT -eq 1 ]
then
	TARFILE_QT=$(basename "${URL_PEAZIP_QT:7}")
	if ! [ -f $TARFILE_QT ]
	then
		wget "$URL_PEAZIP_QT" -O "$TARFILE_QT"
	fi
fi

if [ $MAKE_GTK -eq 1 ]
then
	TARFILE_GTK=$(basename "${URL_PEAZIP_GTK:7}")
	if ! [ -f $TARFILE_GTK ]
	then
		wget "$URL_PEAZIP_GTK" -O "$TARFILE_GTK"
	fi
fi

echo "Installing dependencies..."
echo "--------------------------"

if [ "$VERSION" == "10.8.0" ]
then

	dnf in -y \
	xorg-x11-server-Xvfb patchelf zstd libX11 libX11-xcb xcb-util fontconfig libXrender libXinerama fastfetch zsync strace binutils zlib-ng-compat \
	systemd-libs bzip2-libs libbrotli libglvnd libxml2 xz-libs libcap libXau libglvnd-egl libxkbcommon libglvnd-glx libglvnd-opengl libpng double-conversion pcre2 libXext graphite2 libicu libgomp \

	mkdir -vp extracted

	if [ $MAKE_QT -eq 1 ]
	then

		tar -xvf "$TARFILE_QT" -C extracted
		EXTRACTED="extracted/""$(ls extracted/|sed -n 1p)"
		mv -v "$EXTRACTED" peazip-qt

		dnf -y glew qt6pas qt6-filesystem qt6-qttranslations qt6-qtbase qt6-qtbase-gui

	fi

	if [ $MAKE_GTK -eq 1 ]
	then

		tar -xvf "$TARFILE_GTK" -C extracted
		EXTRACTED="extracted/""$(ls extracted/|sed -n 1p)"
		mv -v "$EXTRACTED" peazip-gtk

		dnf -y gtk2 adwaita-gtk2-theme gtk2-engines cairo pango glycin-libs atk gdk-pixbuf2 gdk-pixbuf2-xlib

	fi

	rmdir -v extracted

fi
