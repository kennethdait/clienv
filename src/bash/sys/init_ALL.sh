#!/usr/bin/env bash
# sys/init_ALL.sh

if
	! which "${CLIENV_DEPS[@]}" &> /dev/null
then
	printf '\n\t[clienv|[31;1mWARN[00m]: %s\n' \
		"some dependencies were not met"
	declare OUTPUT
	OUTPUT=''
	for NAME in "${CLIENV_DEPS[@]}"; do
		if ! which "${NAME}" &> /dev/null; then
			OUTPUT+="\\t   [[31;1mmissing[00m]: ${NAME}\\n"
		fi
	done
	[[ -z "${OUTPUT:-}" ]] \
		&& OUTPUT="\\t  [UNK ERR]\\n"
	echo -e "${OUTPUT}"
	unset OUTPUT
fi

function list () {

	function list_dir_contents_x1 () {
		printf '\n\t[40;33;1m CONTENTS OF: [00m[43;30;1m %s [00m\n\n' "${TARGET}" \
			&& find "${TARGET}" -mindepth 1 -maxdepth 1 \
				| sed -E -e 's:^.*/::' \
				| sed -E -e '/^\./d' \
				| sort \
				| column \
			&& echo;
		return
	}

	function list_pip_packages () {
		/usr/bin/printf '\n\t[43;34;1m PIP LIST: [00m\n\n' \
			&& pip list \
				| /usr/bin/sed '1,2d' \
				| /usr/bin/tr '\t' ' ' \
				| /usr/bin/tr -s ' ' \
				| /usr/bin/sed 's/[ ].*$//' \
				| /usr/bin/sort -df \
				| /usr/bin/column \
			&& builtin echo
		return
	}

	if [[ -n "${1:-}" ]]; then
		if [[ "${1}" == 'pip' ]]; then
			list_pip_packages
			return
		fi
	fi

	local -r TARGET="${1:-"${PWD}"}";

	list_dir_contents_x1
	return
}

