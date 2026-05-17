_c() {
	local services
	services=$(
		docker compose ps --services
	)
	mapfile -t COMPREPLY < <(
		compgen -W "$services" -- "${COMP_WORDS[COMP_CWORD]}"
	)
}
complete -F _c c
