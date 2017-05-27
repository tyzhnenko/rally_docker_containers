#!/bin/bash
set -eu -o pipefail

HOME_CONFIG="${HOME}/.rackspacetruck.cfg"

echo "[nodes]" > "${HOME_CONFIG}"
for i in $(salt-run manage.status | grep " - " | grep "cmp\|ctl" | awk -F  " - " '{print $2}'); do
  IFS='.' read -r -a str <<< ${i}
  number=${str[0]:3}
  case "${i}" in
    *"ctl"*)
        echo "controller_$((number+0)) = ${i}" >> "${HOME_CONFIG}"
        ;;
    *"cmp"*)
        echo "compute_$((number+0)) = ${i}" >> "${HOME_CONFIG}"
        ;;
  esac