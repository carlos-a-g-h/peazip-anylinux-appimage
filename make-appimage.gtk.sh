#!/bin/sh

set -eu

EXTR="peazip-gtk"

ARCH="$(uname -m)"
VERSION="v$(sed -n 1p sources.txt)"

UBID="$1"
UBID_SHORT="${UBID:0:8}"

NAME="PeaZip"
APPIMAGE_STEM="$NAME""-GTK"_"$VERSION"_"$UBID_SHORT"_anylinux_"$ARCH"
export ARCH VERSION
export OUTPATH=./dist
#export ADD_HOOKS="self-updater.bg.hook"
#export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="$EXTR""/res/share/icons/peazip.png"
export OUTNAME="$APPIMAGE_STEM".AppImage
export DESKTOP="peazip.desktop"

export LIB_DIR="/usr/lib64"
export DEPLOY_LOCALE=1
export DEPLOY_OPENGL=0
export DEPLOY_VULKAN=0
export DEPLOY_GEGL=0
export DEPLOY_PULSE=0
export DEPLOY_PIPEWIRE=0
export DEPLOY_GTK=1
export GTK_DIR="gtk-2.0"
export DEPLOY_GDK=1
export DEPLOY_QT=0
export DEPLOY_SDL=0
export DEPLOY_GLYCIN=0
export APPDIR=./appdir-gtk

if ! [ -d "$EXTR" ]
then
	echo "not found: $EXTR"
	exit 0
fi

mkdir -vp "$APPDIR"/bin
cp -va "$EXTR"/* "$APPDIR"/bin/
rm -vrf "$APPDIR"/bin/res/portable
rm -vrf "$APPDIR"/bin/res/conf

# Deploy dependencies

# ./quick-sharun.sh ./"$EXTR"/res/* ./"$EXTR"/peazip ./"$EXTR"/pea
./quick-sharun.sh "$APPDIR"/bin/res/* "$APPDIR"/bin/peazip "$APPDIR"/bin/pea

# Additional changes can be done in between here

# Copy the config
if [ -d _config ]
then
	mkdir -p "$APPDIR"/_config
	cp -va _config/* "$APPDIR"/_config/
fi

# Copy details

mkdir -v "$APPDIR"/_details
echo "$UBID" > "$APPDIR"/_details/commit.txt
echo "$(date)" > "$APPDIR"/_details/date.txt
rpm -qa > "$APPDIR"/_details/packages.txt

fastfetch|sed -e 's/Local IP.*//' -e 's/Locale.*//' -e 's/Battery.*//' -e 's/Disk.*//' -e 's/Swap.*//' > "$APPDIR"/_details/system.txt

US_FILE=$(ls|awk "/peazip_portable/ && /GTK/ && /$VERSION/ && /$ARCH/")
US="$APPDIR"/_details/upstream.txt
touch "$US"
echo "
url" >> "$US"
awk "/peazip_portable/ && /GTK/ && /$VERSION/ && /$ARCH/" sources.txt >> "$US"
echo "
sha256" >> "$US"
sha256sum "$US_FILE" >> "$US"

# Copy Internal scripts

cp -v is_details "$APPDIR"/bin/details
cp -v is_setup.1.sh "$APPDIR"/bin/setup
cat is_setup.2.sh >> "$APPDIR"/bin/setup

chmod +x "$APPDIR"/bin/details
chmod +x "$APPDIR"/bin/setup

# Turn AppDir into AppImage
./quick-sharun.sh --make-appimage
