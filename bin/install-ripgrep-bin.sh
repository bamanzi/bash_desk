#!/bin/sh

PRJNAME=ripgrep

os_n_arch=$(uname -o)-$(uname -m)
case $os_n_arch in
  GNU/Linux-armv7*) bin_arch=armv7-unknown-linux-gnueabihf;  pack=tar.gz;;
  GNU/Linux-aarch64) bin_arch=aarch64-unknown-linux-gnu;  pack=tar.gz;;
  GNU/Linux-x86_64) bin_arch=x86_64-unknown-linux-musl;   pack=tar.gz;;
  GNU/Linux-i*86)   bin_arch=i686-unknown-linux-musl;    pack=tar.gz;;
  Msys-i686)        bin_arch=i686-pc-windows-gnu;       pack=zip;;
  Msys-x86_64)      bin_arch=x86_64-pc-windows-gnu;       pack=zip;;
  *) print "no binary for os/arch '$os_n_arch'."; exit -1;;
esac

BASEURL=https://github.com/BurntSushi/ripgrep/releases

if [ -n "$VER" ]; then
  if which rg; then
    echo "Existing version: $(which rg): $(rg --version 2>&1)"
    ( rg --version 2>&1 | grep $VER ) && echo "You already have latest version." && exit 0
  fi
fi

#use `VER=0.10.0 install-ripgrep-bin.sh` to install specific version
if [ -z "$VER" ]; then
  # find latest version number
  VER=$(wget "$BASEURL" -O - | grep 'releases/tag/' | sed -E 's#.*/releases/tag/([0-9\.]+)".*#\1#' | head -1 )
fi

URL="${BASEURL}/download/${VER}/${PRJNAME}-${VER}-${bin_arch}.${pack}"
echo "About to download version '${VER}' from $URL"  && echo "continue? (press Ctrl-c to abort)" && read a

[ -d ~/temp ] || mkdir ~/temp
(cd ~/temp && wget -c "$URL" -O ${PRJNAME}-${VER}-${bin_arch}.${pack} &&
     (tar xvf ${PRJNAME}-${VER}-${bin_arch}.tar.gz || unzip ${PRJNAME}-${VER}-${bin_arch}.zip))

[ -d ~/bin ] || mkdir ~/bin
cp -f ~/temp/${PRJNAME}-${VER}-${bin_arch}/rg ~/bin
