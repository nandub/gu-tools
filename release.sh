#!/usr/bin/env bash

. ./gu_tools.inc.sh

cmd=$1
if [ "x$cmd" = "x" ]; then
  cmd=patch
fi

VER=$(curl -sL https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver | bash -s -- bump $cmd $(cat VERSION))
NEWVER=v${VER}
read -r -p "Releasing $NEWVER... Press CTRL-c to cancel or Enter to continue.." -n 1 dummy
if asksure; then
  echo ${VER} > VERSION
  git status
  git commit -am "bump to version ${VER}"
  git tag -a ${NEWVER} -m "Version ${VER}"
fi
