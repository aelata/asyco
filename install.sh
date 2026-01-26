#!/bin/bash

# install.sh - install / uninstall 'asyco'
VERSION="\
install.sh version 0.9.0

(c) 2025-2026 aelata
This script is licensed under the MIT No Attribution (MIT-0) License.
https://opensource.org/license/mit-0
"

(( 4 <= BASH_VERSINFO[0] )) && shopt -s compat32 # macOS uses bash 3.2

# quit - write a message $1 to the standard error and exit with the status $2
quit() { echo "$1" >&2; exit "${2:-1}"; }

# warn - write a message ($1) with optional heading ($2) to the standard error
warn() { echo "WARNING: $*" >&2; }

SCRIPT0=${BASH_SOURCE:-$0}
SCRIPT=$(basename "$SCRIPT0")
[[ $SCRIPT != install.sh && $SCRIPT != uninstall.sh ]] &&
  quit "$SCRIPT0: unknown script name: $SCRIPT"

CWD=$(dirname "$(realpath "$SCRIPT0")") # directory where script is located

# tools to be installed
SRCS=(asyco asycat)
MSRCS=(mepoco)

DRY=""              # dry-run

flg_link=false      # create symbolic links
flg_mepo=false      # install mepoco

[[ $SCRIPT != install.sh ]] && o="" || o="
  -l Create symbolic links instead of copying files
  -m Add a symbolic link to mepoco"
s=${SCRIPT%%.*} # install or uninstall
USAGE="\
$SCRIPT - ${s}er for asyco

Usage: $SCRIPT [options] DEST_DIR

Options:$o
  -n Show the ${s}ation commands to run without executing them (dry run)
  -h Show this message and exit
  -v Show version information and exit
"

parse_args() {
  [[ $SCRIPT == install.sh ]] && opts="hlmnv" || opts="hnv"
  while getopts "$opts" o; do
    case "$o" in
    h) quit "$USAGE" 0 ;;
    l) flg_link=true ;;
    m) flg_mepo=true ;;
    n) DRY="echo DRY-RUN: " ;;
    v) quit "$VERSION" 0 ;;
    \?) exit 1 # quit $'\n'"$USAGE"
    esac
  done
  shift $((OPTIND - 1))
  [[ $# == 0 ]] && quit "$USAGE" 0
  [[ $# == 1 ]] || quit "$USAGE"
  [[ -d $1 ]] || quit "ERROR: '$1' is not directory"
  DEST=$(realpath "$1") # absolute path
  [[ $CWD == "$DEST" ]] &&
    quit "ERROR: destination cannot be script directory: $DEST"
}

_cd() { # $1: destination directory
  cd "$1" || quit "ERROR: cannot change directory: $1"
  [[ -n $DRY ]] && $DRY cd "$1"
}

_rm() { # $@: files to be removed
  for f in "$@"; do
    [[ -f $f || -L $f ]] && $DRY rm -f "$f"
  done
}

_uninstall() {
  _cd "$DEST"
  [[ $SCRIPT == uninstall.sh || $flg_mepo != false ]] && _rm "${MSRCS[@]}"
  _rm "${SRCS[@]}"
}

_install() {
  [[ ":$PATH:" == *":$DEST:"* ]] || warn "$0: '$DEST' is not in PATH"
  _cd "$CWD"
  for x in "${SRCS[@]}"; do
    if [[ $flg_link == false ]]; then
      $DRY cp "$x" "$DEST" # should use external command 'install'?
    else
      $DRY ln -s "$PWD/$x" "$DEST"
    fi
  done
  _cd "$DEST"
  $DRY chmod +x "${SRCS[@]}"
  [[ $flg_mepo != false ]] && for x in "${MSRCS[@]}"; do
    $DRY ln -s "${x/mepo/asy}" "$x"
  done
}

main() {
  parse_args "$@"
  ( _uninstall )
  [[ $SCRIPT == install.sh ]] && _install
}

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@" # skip if sourced (return 0)
