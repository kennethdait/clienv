#!/usr/bin/env bash
# sys/init_Darwin.sh

if ! echo "${PATH}" | grep -Eq -e '/usr/local/opt/python/libexec/bin'; then
	export PATH=/usr/local/opt/python/libexec/bin"${PATH:+":${PATH}"}"
fi

if ! echo "${PATH}" | grep -Eq -e '/usr/local/sbin'; then
	export PATH="${PATH:+"${PATH}:"}"/usr/local/sbin
fi


if command -v system_profiler &> /dev/null; then
	disks ()
	{
			{
					/usr/sbin/system_profiler SPStorageDataType \
						| grep -E -v '^[[:blank:]]*$' \
						| sed '1d' \
						| cut -c5- \
						| grep -E '(Free|Capacity):' \
						| sort \
						| uniq \
						| sed -E -e 's/^[[:blank:]]*([^:]+:)[^(]+\(([^ ]+) .*$/\1\2/'
			} \
				| tr -d ',' \
				| awk -F":" '
						{
							BYTES=$2; KB=(BYTES/1000); MB=(KB/1000); GB=(MB/1000);
							printf ("%s:%f %s:", $1, GB, "GB")
						}
					' \
				| sed 's/:$//' \
				| awk -F":" '
						{
							TOTAL=$2; FREE=$4; PCT_FREE=(FREE/TOTAL*100)
							printf ("AVAILABLE DISK SPACE: %4.2f%%\n", PCT_FREE)
						}
					';
			return
	}
fi

function homedirs () {
    function size_report ()
    {
			while IFS= read -r DIR; do
				du -sm "${DIR}";
			done < <(find ~ -maxdepth 1 -mindepth 1 -name "[A-KM-Z]*") \
				| sort -nr \
				| awk -Ft '
					{
						printf ("%8d MB  =>  %s\n", $1, $2)
					}
				' \
				| sed -E -e "s:${HOME}/::";
			return
    };
    printf '\n\tHOME DIR FOLDERS:\n\n%s\n\n' "$(size_report)";
    return
}

function update () { 
    local list;
    list="$(softwareupdate --list --all 2>&1 > /dev/null)";
    if [[ "${list}" == 'No new software available.' ]]; then
        echo "[SOFTWAREUPDATE]: <NONE>";
    else
        echo "${list}";
    fi;
    return
}

