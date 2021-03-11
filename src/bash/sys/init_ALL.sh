#!/usr/bin/env bash
# sys/init_ALL.sh

declare OUTPUT
OUTPUT=''

# VERIFY COMMAND DEPENDENCIES
if ! which "${CLIENV_CMD_DEPS[@]}" &> /dev/null; then
	printf '\n\t[clienv|[31;1mWARN[00m]: %s\n' \
		"some dependencies were not met"
	for NAME in "${CLIENV_CMD_DEPS[@]}"; do
		if ! which "${NAME}" &> /dev/null; then
			OUTPUT+="\\t   [[31;1mmissing[00m]: ${NAME}\\n"
		fi
	done
fi

# VERIFY REPO DEPENDENCIES
if (( ${#CLIENV_REPO_DEPS[@]} > 0 )); then
	for REPO in "${CLIENV_REPO_DEPS[@]}"; do
		REPONAME="${REPO%%:*}"
		REPOPATH="${REPO#*:}"
		if [[ ! -d "${REPOPATH}/.git" ]]; then
			OUTPUT+="\\t  [[31;1mmissing repo[00m]: ${REPONAME}\\n"
		fi
	done
fi

# VERIFY PYTHON VERSION 3+
if which python &> /dev/null; then
	while IFS=$' \n' read -r V{1,2,3}; do
			if (( V1 < 3 )); then
					#echo -e "\\t  [[31;1mERR[00m]: PYTHON OUT OF DATE -- ${V1}.${V2}.${V3}" >&2;
					OUTPUT+="\\t  [[31;1mOLD PYTHON VERSION[00m]: ${V1}.${V2}.${V3}\\n"
			fi;
	done < <(python --version 2>&1 | cut -d' ' -f2 | tr '.' ' ');
fi

#[[ -z "${OUTPUT:-}" ]] && OUTPUT="\\t  [UNK ERR]\\n"
echo -e "${OUTPUT}"
unset OUTPUT

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

function clienv () {

	function go_to_clienv () {
		[[ -z "${clienv:-}" ]] && return 12
		cd "${clienv}" || return 13
		printf '  [git pull]... '
		if /usr/bin/git pull &> /dev/null; then
			echo "SUCCESS"\!
			return 0
		else
			echo "FAILED TO PULL"\! >&2
			return 14
		fi
		return 15
	}

	function list_bash_files () {
		/usr/bin/find "${clienvbash:-}" -type f \! \( -name "*.sw[a-z]" -or -empty \) -exec printf '%s|' "{}" \; -exec basename "{}" \; \
			| /usr/bin/awk -F"|" '
				NF==2{
					printf ("\t%*.*s => %s\n", -20, 20, $2, $1)
				}
			'
		return
	}

	if (($#>0)); then
		case "${1}" in
			go)
				go_to_clienv
				return $?
				;;
			b|bash)
				list_bash_files
				return
				;;
			*)
				printf '[ERR]: unrecognized subcommand -- %s\n' "${1}" >&2
				return 11
				;;
		esac
	elif (($#==0)); then
		go_to_clienv
		return $?
	fi
	return
}

function repos () {
	local TARGET DEF_TARGET; DEF_TARGET=~/Developer
	TARGET="${DEF_TARGET}"
	local -i OPTIND
	while getopts :t: OPT; do
		case "$OPT" in
			t)
				TARGET="${OPTARG}"
				;;
			:)
				#shellcheck disable=2016
				/usr/bin/printf '[ERR]: flag requires an argument -- `-%s`\n' "${OPTARG}" >&2
				;;
			*)
				/usr/bin/printf '[ERR]: invalid flag -- %s\n' "${OPTARG}" >&2
				;;
		esac
	done; shift $((OPTIND-1))

	printf '\n  [SEARCHING REPOS IN]: %s\n\n' "${TARGET}" \
		&& while IFS=$'\n' read -r DIRPATH; do
			   BN="$(basename "$DIRPATH")"
				 echo -e "${BN}|${DIRPATH}"
		   done < <(/usr/bin/find "${TARGET}" -type d -name ".git" -exec dirname "{}" \; 2> /dev/null) \
			| /usr/bin/sed -E -e "s|${HOME}|~|" \
			| /usr/bin/awk -F"|" '
				NF==2{
					printf ("[35;1m%*.*s[00m => %s\n", -30, 30, $1, $2)
				}
			' \
			| /usr/bin/cut -c1-${COLUMNS:-$(tput cols)} \
		&& builtin echo

	return
}

