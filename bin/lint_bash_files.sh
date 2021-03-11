#!/usr/bin/env bash
# lint_bash_files.sh

declare FILEPATH lint_output_type
lint_output_type='gcc'

while IFS=$'\n' read -r FILEPATH; do
	[[ -z "${FILEPATH:-}" ]] && continue
	echo "--${FILEPATH}--";
	/usr/local/bin/shellcheck -f "${lint_output_type:?}" -xa "${FILEPATH}";
done < <(find "${clienvbash:?}" -type f \! \( -empty -or -name "*.sw[a-z]" \)) \
	| sed -E \
			-e '/^\//s/^.*(warning:).*$/[43;30m&[00m/' \
			-e '/^\//s/^.*(error:).*$/[41;37;1m&[00m/' \
			-e '/^\//s/^.*(info:).*$/[44;37m&[00m/'  \
			-e '/^\//s/^.*(error:).*$/[41;37;1m&[00m/' \
			-e '/^\//s/^.*(style:).*$/[36m&[00m/'

unset FILEPATH lint_output_type

exit

