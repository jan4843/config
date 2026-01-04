_heredocker() {
	local images
	images=$(
		docker image ls | awk '/^[a-z]/{print $1 ":" $2}' |
		grep -v '<none>' |
		sed 's/:latest$//'
	)
	mapfile -t COMPREPLY < <(
		compgen -W "$images" -- "${COMP_WORDS[COMP_CWORD]}"
		compgen -d -- "${COMP_WORDS[COMP_CWORD]}"
	)
}
complete -F _heredocker @
