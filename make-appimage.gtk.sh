#!/bin/sh

set -eu

ARCH="$(uname -m)"
VERSION="v$(sed -n 1p version.txt)"

UBID="$1"
UBID_SHORT="${UBID:0:8}"

NAME="PeaZip"
APPIMAGE_STEM="$NAME""-GTK"_"$VERSION"_"$UBID_SHORT"_anylinux_"$ARCH"
export ARCH VERSION
export OUTPATH=./dist
#export ADD_HOOKS="self-updater.bg.hook"
#export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="peazip-gtk/res/share/icons/peazip.png"
export OUTNAME="$APPIMAGE_STEM".AppImage
export DESKTOP="peazip.desktop"

export DEPLOY_LOCALE=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=0
export DEPLOY_GEGL=0
export DEPLOY_PULSE=0
export DEPLOY_PIPEWIRE=0
export DEPLOY_GTK=1
export DEPLOY_GDK=1
export DEPLOY_QT=0
export DEPLOY_SDL=0
export DEPLOY_GLYCIN=0
export APPDIR=./appdir-gtk

mkdir -p "$APPDIR"/bin
cp -va peazip-gtk/* "$APPDIR"/bin/
rm -vrf "$APPDIR"/bin/res/portable
rm -vrf "$APPDIR"/bin/res/conf

# Deploy dependencies
./quick-sharun.sh ./peazip-gtk/res/* ./peazip-gtk/peazip ./peazip-gtk/pea

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
sed -n 3p version.txt > "$APPDIR"/_details/upstream.txt
fastfetch|sed -e 's/Local IP.*//' -e 's/Locale.*//' -e 's/Battery.*//' -e 's/Disk.*//' -e 's/Swap.*//' > "$APPDIR"/_details/system.txt

# Copy Internal scripts
# mkdir -vp "$APPDIR"/bin

cp -v is_details "$APPDIR"/bin/details
cp -v is_setup.1.sh "$APPDIR"/bin/setup
cat is_setup.2.sh >> "$APPDIR"/bin/setup

chmod +x "$APPDIR"/bin/details
chmod +x "$APPDIR"/bin/setup

# Turn AppDir into AppImage
./quick-sharun.sh --make-appimage
