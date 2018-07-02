#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs gu-tools under $PREFIX.

set -e

cd "$(dirname "$0")"

data_include=$(cat gu_tools.inc.sh | tr '\n' '^' | sed 's/\//SLASH/g')
version=$(cat VERSION)
mkdir -p bin
for f in gprune.in gucl.in gucr.in gume.in
do
  name=$(echo $f | awk -F'.' '{print $1}')
  sed 's/m4_include(gu_tools.inc.sh)/\^/g' $f | sed "s/@VERSION@/$version/g" | sed "s/\^/$data_include/g" > bin/cmd.new
  cat bin/cmd.new | sed 's/SLASH/\//g' | tr '^' '\n' > bin/$name
  rm  bin/cmd.new
done

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"

mkdir -p "$BIN_PATH"

install -p bin/* "$BIN_PATH"
