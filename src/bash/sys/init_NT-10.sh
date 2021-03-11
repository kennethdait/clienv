#!/usr/bin/env bash
# sys/init_NT-10.sh

printf '\n\t[clienv]: %s\n\n' "\$clienv/src/bash/sys/init_NT-10.sh sourced..."

if [[ "${TERM_PROGRAM}" == 'mintty' ]]; then
	export PATH=/c/nodejs"${PATH:+":${PATH}"}"
fi
