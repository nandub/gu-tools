#!/bin/sh
# Script is based from https://github.com/zeit/install-node.now.sh
#
# Semver also works (ex: v0.0.1):
#
#   $ curl -sL install-gu-tools.now.sh/v0.0.1 | sh
#
# Options may be passed to the shell script with `-s --`:
#
#   $ curl -sL install-gu-tools.now.sh | sh -s -- --prefix=$HOME --version=8 --verbose
#   $ curl -sL install-gu-tools.now.sh | sh -s -- -P $HOME -v 8 -V
#
set -euo pipefail

BOLD="$(tput bold 2>/dev/null || echo '')"
GREY="$(tput setaf 0 2>/dev/null || echo '')"
UNDERLINE="$(tput smul 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
MAGENTA="$(tput setaf 5 2>/dev/null || echo '')"
CYAN="$(tput setaf 6 2>/dev/null || echo '')"
NO_COLOR="$(tput sgr0 2>/dev/null || echo '')"

info() {
  printf "${BOLD}${GREY}>${NO_COLOR} $@\n"
}

warn() {
  printf "${YELLOW}! $@${NO_COLOR}\n"
}

error() {
  printf "${RED}x $@${NO_COLOR}\n" >&2
}

complete() {
  printf "${GREEN}✓${NO_COLOR} $@\n"
}

fetch() {
  local command
  if hash curl 2>/dev/null; then
    set +e
    command="curl --silent --fail -L $1"
    curl --silent --fail -L "$1"
    rc=$?
    set -e
  else
    if hash wget 2>/dev/null; then
      set +e
      command="wget -O- -q $1"
      wget -O- -q "$1"
      rc=$?
      set -e
    else
      error "No HTTP download program (curl, wget) found…"
      exit 1
    fi
  fi

  if [ $rc -ne 0 ]; then
    error "Command failed (exit code $rc): ${BLUE}${command}${NO_COLOR}"
    exit $rc
  fi
}

resolve_tools_version() {
  local tag="$1"
  if [ "${tag}" = "latest" ]; then
    tag=v$(fetch https://raw.githubusercontent.com/nandub/gu-tools/master/VERSION)
  fi
  #whether they pass a v or not for version.
  newtag=$(echo $tag | sed 's/v//')
  echo v$newtag
}

# Currently known to support:
#   - win (Git Bash)
#   - darwin
#   - linux
#   - linux_musl (Alpine)
detect_platform() {
  local platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  # check for MUSL
  if [ "${platform}" = "linux" ]; then
    if ldd /bin/sh | grep -i musl >/dev/null; then
      platform=linux_musl
    fi
  fi

  # mingw is Git-Bash
  if echo "${platform}" | grep -i mingw >/dev/null; then
    platform=win
  fi

  echo "${platform}"
}

confirm() {
  if [ -z "${FORCE-}" ]; then
    printf "${MAGENTA}?${NO_COLOR} $@ ${BOLD}[yN]${NO_COLOR} "
    set +e
    read yn < /dev/tty
    rc=$?
    set -e
    if [ $rc -ne 0 ]; then
      error "Error reading from prompt (please re-run with the \`--yes\` option)"
      exit 1
    fi
    if [ "$yn" != "y" ] && [ "$yn" != "yes" ]; then
      error "Aborting (please answer \"yes\" to continue)"
      exit 1
    fi
  fi
}

check_prefix() {
  local bin="$1/bin"

  # https://stackoverflow.com/a/11655875
  local good=$( IFS=:
    for path in $PATH; do
      if [ "${path}" = "${bin}" ]; then
        echo 1
        break
      fi
    done
  )

  if [ "${good}" != "1" ]; then
    warn "Prefix bin directory ${bin} is not in your \$PATH"
  fi
}

# defaults
if [ -z "${VERSION-}" ]; then
  VERSION=latest
fi

if [ -z "${PLATFORM-}" ]; then
  PLATFORM="$(detect_platform)"
fi

if [ -z "${PREFIX-}" ]; then
  PREFIX=/usr/local
fi

# parse argv variables
while [ "$#" -gt 0 ]; do
  case "$1" in
    -v|--version) VERSION="$2"; shift 2;;
    -P|--prefix) PREFIX="$2"; shift 2;;
    -V|--verbose) VERBOSE=1; shift 1;;
    -f|-y|--force|--yes) FORCE=1; shift 1;;

    -v=*|--version=*) VERSION="${1#*=}"; shift 1;;
    -P=*|--prefix=*) PREFIX="${1#*=}"; shift 1;;
    -V=*|--verbose=*) VERBOSE="${1#*=}"; shift 1;;
    -f=*|-y=*|--force=*|--yes=*) FORCE="${1#*=}"; shift 1;;

    -*) error "Unknown option: $1"; exit 1;;
    *) VERSION="$1"; shift 1;;
  esac
done

# Resolve the requested version tag into an existing gu-tools version
RESOLVED="$(resolve_tools_version "$VERSION")"
if [ -z "${RESOLVED}" ]; then
  error "Could not resolve gu-tools version ${MAGENTA}${VERSION}${NO_COLOR}"
  exit 1
fi

PRETTY_VERSION="${GREEN}${RESOLVED}${NO_COLOR}"
if [ "$RESOLVED" != "v$(echo "$VERSION" | sed 's/^v//')" ]; then
  PRETTY_VERSION="$PRETTY_VERSION (resolved from ${CYAN}${VERSION}${NO_COLOR})"
fi
printf "  ${UNDERLINE}Configuration${NO_COLOR}\n"
info "${BOLD}Version${NO_COLOR}:  ${PRETTY_VERSION}"
info "${BOLD}Prefix${NO_COLOR}:   ${GREEN}${PREFIX}${NO_COLOR}"
info "${BOLD}Platform${NO_COLOR}: ${GREEN}${PLATFORM}${NO_COLOR}"

# non-empty VERBOSE enables verbose untarring
if [ ! -z "${VERBOSE-}" ]; then
  VERBOSE=v
  info "${BOLD}Verbose${NO_COLOR}: yes"
else
  VERBOSE=
fi

echo

EXT=tar.gz
if [ "${PLATFORM}" = win ]; then
  EXT=zip
fi

URL="https://github.com/nandub/gu-tools/archive/${RESOLVED}.${EXT}"
info "Tarball URL: ${UNDERLINE}${BLUE}${URL}${NO_COLOR}"
check_prefix "${PREFIX}"
confirm "Install gu-tools ${GREEN}${RESOLVED}${NO_COLOR} to ${BOLD}${GREEN}${PREFIX}${NO_COLOR}?"

info "Installing gu-tools, please wait…"

if [ "${EXT}" = zip ]; then
  fetch "${URL}" \
    | tar xzf${VERBOSE} - \
      --exclude LICENSE \
      --exclude README.md \
      --exclude .gitignore
else
  fetch "${URL}" \
    | tar xzf${VERBOSE} - \
      --exclude LICENSE \
      --exclude README.md \
      --exclude .gitignore
fi
dir=$(echo ${RESOLVED} | sed 's/v//')
cd gu-tools-$dir

data_include=$(cat gu_tools.inc.sh | tr '\n' '^' | sed 's/\//SLASH/g' | sed 's/\&/AMP/g')
mkdir -p bin
files=$(ls -1 *.in)
for f in $files
do
  name=$(echo $f | awk -F'.' '{print $1}')
  sed 's/m4_include(gu_tools.inc.sh)/\^/g' $f | sed "s/@VERSION@/${RESOLVED}/g" | sed "s/\^/$data_include/g" > bin/cmd.new
  cat bin/cmd.new | sed 's/AMP/\&/g' | sed 's/SLASH/\//g' | tr '^' '\n' > bin/$name
  rm  bin/cmd.new
done

BIN_PATH="${PREFIX}/bin"

mkdir -p "$BIN_PATH"

install -p bin/* "$BIN_PATH"

complete "Done"
