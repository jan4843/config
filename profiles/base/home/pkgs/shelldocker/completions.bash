_shelldocker() {
	local containers
	containers=$(
		docker container ls --format '{{.Names}}' 2>/dev/null ||
		docker ls --quiet
	)
	mapfile -t COMPREPLY < <(
		compgen -W "$containers" -- "${COMP_WORDS[COMP_CWORD]}"
	)
}
complete -F _shelldocker shelldocker
