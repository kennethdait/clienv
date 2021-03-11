#!/usr/bin/env bash
# status.sh
# clienv

function systemReport_macos () {
  /usr/sbin/system_profiler SPSoftwareDataType \
    | /usr/bin/sed -n '5,$p' \
    | /usr/bin/sed '$d' \
    | /usr/bin/sed -E \
      -e 's/^[[:blank:]]*(.*)[[:blank:]]*$/\1/' \
      -e 's/:[[:blank:]]*/:/' \
    | /usr/bin/awk -F":" '
      {
        printf ("%*s => %s\n",30,$1,$2)
      }
    '
  return
}

function systemReport_linux () {
  echo "${sysname:-}"
  return
}

function systemReport_windows () {
  local TERMPROG
  TERMPROG="${TERM_PROGRAM:-"<NULL>"}"
  
  echo "${sysname:-}"
  echo "TERM PROGRAM: ${TERMPROG}"
  return
}

declare sysname sysdetails
sysname="$(/usr/bin/uname | /usr/bin/tr 'A-Z' 'a-z')"

case "${sysname}" in
  'darwin')
    sysname='macOS'
    systemReport_macos
    ;;
  'linux')
    sysname='Linux'
    systemReport_linux
    ;;
  *_nt-10*)
    sysname='Windows'
    systemReport_windows
    ;;
  *)
    printf '\t[ERROR]: %s -- %s\n' "system not recognized" "${sysname}" >&2
    exit 11
    ;;
esac

