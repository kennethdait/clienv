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

