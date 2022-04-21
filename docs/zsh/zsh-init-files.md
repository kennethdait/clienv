# zsh initialisation

## initialisation files (`man zsh`)

- ${ZDOTDIR:-"${HOME}"}/.zshenv
- ${ZDOTDIR:-"${HOME}"}/.zprofile
- ${ZDOTDIR:-"${HOME}"}/.zshrc
- ${ZDOTDIR:-"${HOME}"}/.zlogin
- ${ZDOTDIR:-"${HOME}"}/.zlogout
- ${TMPPREFIX}\* (default is /tmp/zsh\*)
- /etc/zshenv
- /etc/zprofile
- /etc/zshrc
- /etc/zlogin
- /etc/zlogout (installation-specific - /etc is the default)

## initialisation variables

- ZDOTDIR: path to user zsh configuration files (HOME is used if ZDOTDIR is unset)

## about zsh options (`man zshoptions`)

- options are primarily referred to by name, case insensitive, underscores are ignored
	- i.e. `allexport` is equivalent to `A__lleXP_ort`
	- the "sense" of an option may be inverted by preceding it with `no'
		- i.e. `setopt No\_beep` is equivalent to `unsetopt beep`
- some options have one or more single-letter names
	- two sets of single-letter options: one by default, another to emulate sh/ksh
	- can be used on shell command line, or with the set`, `setopt`, or `unsetopt` builtins, preceded by `-`
	- the "sense" of single-letter options can be inverted by using `+` instead of `-`

## zsh initialisation options

- ALL\_EXPORT
- GLOBAL\_EXPORT
- GLOBAL\_RCS
- RCS

## initialization

1. source /etc/zshenv (cannot be overridden)
2. RCS/GLOBAL\_RCS options
	- what happens next is modified by the `RCS` and `GLOBAL_RCS` options
	- RCS: affects all startup files
	- GLOBAL\_RCS: only affects global startup files
	- at any point during initialization, if one of these options is unset:
		- subsequent files of the corresponding type will not be sourced
	- it is possible for a file in $ZDOTDIR to re-enable GLOBAL\_RCS
3. source ${ZDOTDIR:-"$HOME"}/.zshenv
4. if shell is a *login* shell:
	- 4a. source /etc/zprofile
	- 4b. source ${ZDOTDIR:-"$HOME"}/.zprofile
5. if shell is *interactive*:
	- source /etc/zshrc
	- source ${ZDOTDIR:-"$HOME"}/.zshrc
6. finally, if shell is *login* shell:
	- 6a. source /etc/zlogin
	- 6b. source ${ZDOTDIR:-"$HOME"}/.zlogin
6. When a *login* shell exits:
	- source ${ZDOTDIR:-"$HOME"}/.zlogout
	- source /etc/zlogout
	- note:
		- this happens with an explicit `exit` or `logout` command, or an implicit exit by reading EOF from the terminal
		- if the shell terminates due to `exec`-ing another process, the logout files are *not* read
		- affected by the RCS and GLOBAL\_RCS options
		- RCS option affects the saving of history files
			- i.e. if RCS is unset when shell exits, no history file will be saved

## initialisation note

- as /etc/zshenv is run for *all* instances of zsh, it is important that it be kept as *small* as possible
	- put code that *does not* need to run for every single shell behind a test of the form:
		- `if [[ -o rcs ]]; then ...`
	- this prevents execution of unecessary code when zsh is invoked with the `-f` option
- any of these files may be *pre-compiled* with the `zcompile` builtin command (see _zshbuiltins(1)_)
	- compiled files will be named for the original file plus the `.zwc` extension
	- if a compiled file exists, and is *newer* than the original file, the compiled file will be used instead


