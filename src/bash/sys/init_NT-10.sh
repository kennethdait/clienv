#!/usr/bin/env bash
# sys/init_NT-10.sh

printf '\n\t[clienv]: %s\n\n' "\$clienv/src/bash/sys/init_NT-10.sh sourced..."

if [[ "${TERM_PROGRAM}" == 'mintty' ]]; then
	export PATH=/c/nodejs"${PATH:+":${PATH}"}"
fi


winproc () 
{ 
	function get_task_list() {
		tasklist | tr '\t' ' ' | tr -s ' ' | sed -E -e 's/[[^::blank:]]*(.*)[[:blank:]]*$/\1/g' | sed 's/ K$/K/' | sed -E -e 's/,([0-9]+)/\1/'
		return
	}
	while IFS=$' \n' read -r NAME ID GROUP XX SIZE; do
			printf '\t%50s: !%-10s %s\n' "${NAME}" "${ID}" "${SIZE}";
	done < <(get_task_list);
	return
}
