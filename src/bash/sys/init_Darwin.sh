#!/usr/bin/env bash
# sys/init_Darwin.sh

#printf '\n\t[clienv]: %s\n\n' "\$clienv/src/bash/sys/init_Darwin.sh sourced..."

if ! echo "${PATH}" | grep -Eq -e '/usr/local/opt/python/libexec/bin'; then
	export PATH=/usr/local/opt/python/libexec/bin"${PATH:+":${PATH}"}"
fi

