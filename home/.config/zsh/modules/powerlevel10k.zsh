system-zsh-preview-prompt-colors() {
	local i
	for i in {0..255}; do
		printf '\e[38;5;%dm%3d thinkpad .config/zsh main ❯\e[0m\n' $i $i
	done
}

function _p10k_vcs_dot() {
	emulate -L zsh
	local dot action
	if ((VCS_STATUS_NUM_CONFLICTED)); then
		dot='%F{1}✗%f'
	elif ((VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED)); then
		dot='%F{2}●%f'
	elif ((VCS_STATUS_COMMITS_BEHIND)); then
		dot='%F{3}●%f'
	else
		dot='%F{8}●%f'
	fi
	[[ $VCS_STATUS_ACTION == *rebase* ]] && action=' %F{1}[*]%f'
	typeset -g _p10k_vcs_format="${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT[1,8]}} ${dot}${action}"
}
functions -M _p10k_vcs_dot 2>/dev/null

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
	emulate -L zsh -o extended_glob
	unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
	[[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

	typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
		context
		dir
		vcs
		status
		prompt_char
	)
	typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

	typeset -g POWERLEVEL9K_MODE=nerdfont-v3
	typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
	typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
	typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
	typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

	typeset -g POWERLEVEL9K_BACKGROUND=''
	typeset -g POWERLEVEL9K_ICON_PADDING=none
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

	typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%m'
	typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION='%m'
	typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_CONTENT_EXPANSION=' %m'
	local _host_color
	case ${(L)HOST%%.*} in
	thinkpad) _host_color=137 ;;
	*) _host_color=99 ;;
	esac
	typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO,REMOTE,REMOTE_SUDO}_FOREGROUND=$_host_color
	typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=''
	typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO,REMOTE,REMOTE_SUDO}_BACKGROUND=''
	typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION=''
	typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

	typeset -g POWERLEVEL9K_DIR_BACKGROUND=''
	typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=''
	typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
	typeset -g POWERLEVEL9K_DIR_FOREGROUND=3
	typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=8
	typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=3
	typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
	typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.bzr|CVS|.git|.hg|.svn|.terraform|.citc|flake.nix|package.json|Cargo.toml|go.mod)'
	typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=20
	typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
	typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50

	typeset -g POWERLEVEL9K_VCS_FOREGROUND=8
	typeset -g POWERLEVEL9K_VCS_BACKGROUND=''
	typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=''
	typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
	typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_FOREGROUND=8
	typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_BACKGROUND=''
	typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((_p10k_vcs_dot()))+${_p10k_vcs_format}}'

	typeset -g POWERLEVEL9K_STATUS_OK=false
	typeset -g POWERLEVEL9K_STATUS_ERROR=true
	typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=9
	typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=''
	typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION=''
	typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION=''
	typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
	typeset -g POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='!(${P9K_CONTENT})'

	typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=7
	typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=7
	typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=''
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

	((!$+functions[googley_p10k_post_config])) || p10k_post_config
}

((${#p10k_config_opts})) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

autoload -Uz add-zsh-hook
_p10k_output_spacing() { print ""; }
add-zsh-hook preexec _p10k_output_spacing
