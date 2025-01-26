_shelldocker() {
	local containers
	containers=$(
		docker container ls --format '{{.Names}}'
	)
	mapfile -t COMPREPLY < <(
		compgen -W "$containers" -- "${COMP_WORDS[COMP_CWORD]}"
	)
}
complete -F _shelldocker shelldocker
