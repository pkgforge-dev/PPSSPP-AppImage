#!/bin/sh

set -eu

PACKAGE=ppsspp
DESKTOP=PPSSPPSDL.desktop
ICON=ppsspp.png

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1
export VERSION=$(pacman -Q "$PACKAGE" | awk 'NR==1 {print $2; exit}')
echo "$VERSION" > ~/version

UPINFO="gh-releases-zsync|$(echo "$GITHUB_REPOSITORY" | tr '/' '|')|latest|*$ARCH.AppImage.zsync"
LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
URUNTIME="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-$ARCH"
# Prepare AppDir
mkdir -p ./AppDir/shared/lib \
	./AppDir/usr/share \
	./AppDir/bin
cd ./AppDir

cp -v /usr/share/applications/"$DESKTOP"            ./
cp -v /usr/share/icons/hicolor/256x256/apps/"$ICON" ./
cp -v /usr/share/icons/hicolor/256x256/apps/"$ICON" ./.DirIcon

cp -rv /usr/share/ppsspp  ./usr/share
ln -s ../usr/share/ppsspp/assets ./bin
ln -s ./usr/share ./

# ADD LIBRARIES
wget "$LIB4BN" -O ./lib4bin
chmod +x ./lib4bin
xvfb-run -d -- ./lib4bin -p -v -e -s -k \
	/usr/bin/PPSSPPSDL \
	/usr/bin/PPSSPPHeadless \
	/usr/lib/libSDL* \
	/usr/lib/libvulkan* \
	/usr/lib/libEGL* \
	/usr/lib/libGL* \
	/usr/lib/dri/* \
	/usr/lib/libXss.so* \
	/usr/lib/pulseaudio/* \
	/usr/lib/pipewire-0.3/* \
	/usr/lib/spa-0.2/*/*

# Prepare sharun
echo "Preparing sharun..."
ln -s ./bin/PPSSPPSDL ./AppRun
./sharun -g

# MAKE APPIMAGE WITH URUNTIME
cd ..
wget -q "$URUNTIME" -O ./uruntime
chmod +x ./uruntime

#Add udpate info to runtime
echo "Adding update information \"$UPINFO\" to runtime..."
./uruntime --appimage-addupdinfo "$UPINFO"

echo "Generating AppImage..."
./uruntime --appimage-mkdwarfs -f \
	--set-owner 0 --set-group 0 \
	--no-history --no-create-timestamp \
	--compression zstd:level=22 -S26 -B8 \
	--header uruntime \
	-i ./AppDir -o "$PACKAGE"-"$VERSION"-anylinux-"$ARCH".AppImage

wget -qO ./pelf "https://github.com/xplshn/pelf/releases/latest/download/pelf_$(uname -m)" && chmod +x ./pelf
echo "Generating [dwfs]AppBundle...(Go runtime)"
./pelf --add-appdir ./AppDir \
	    --appbundle-id="${PACKAGE}-${VERSION}" \
     	    --compression "-C zstd:level=22 -S26 -B8" \
	    --output-to "${PACKAGE}-${VERSION}-anylinux-${ARCH}.dwfs.AppBundle"

echo "Generating zsync file..."
zsyncmake *.AppImage -u *.AppImage
zsyncmake *.AppBundle -u *.AppBundle

echo "All Done!"
