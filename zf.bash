_zf_comp() 
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	
	if [[  ${COMP_CWORD} -eq 1 ]]; then
		opts="change configure create disable enable show"
		
	elif [[ ${COMP_CWORD} -eq 2 ]]; then
	
		case "${prev}" in
			show)
				opts="version config manifest profile project"
				;;
			create)
				opts="config project model view controller action module form db-table project-provider"
				;;
			change)
				opts="application.class-name-prefix"
				;;
			enable)
				opts="layout"
				;;
			disable)
				opts="layout"
				;;
			configure)
				opts="db-adapter"
				;;
		esac
	fi

	COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  
	return 0
}

complete -F _zf_comp zf