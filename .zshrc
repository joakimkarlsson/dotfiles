# vim:foldmethod=marker

#
# Add custom directory for my functions to fpath
#
# fpath=($fpath ~/.zshfunctions)
fpath=($fpath ~/.zsh)

# {{{ The following lines were added by compinstall
zstyle :compinstall filename '/home/jkr/.zshrc'

autoload -Uz compinit
compinit
# }}}

# {{{ Spped up autocompletion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' hosts off
zstyle ':completion:*:git:*' tag-order 'common-commands'

#
# Disable autocompletion from getting git info
#
__git_files () {
    _wanted files expl 'local files' _files
}
# }}}

# {{{ Setup environment
#
# Load $fg & co with color codes
#
autoload -U colors && colors

#
# Ensure user binaries are available.
#
export PATH=$PATH:${HOME}/bin

#
# Set language in shell
#
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

export EDITOR=vim

# }}}


# {{{ Behavior

bindkey -e
# {{{ Vim keybindings
# bindkey -v
# bindkey -M vicmd '?' history-incremental-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
# }}}

# Remember history
HISTSIZE=1000
HISTFILE=~/.history
SAVEHIST=1000
# }}}

# {{{ Functions

#
# Print nerdfont characters
#
function nerdfont() {
    echo -e $(printf "\\\\u%x\n" $(seq $((16#e000)) $((16#f200))))
}


#
# Add a project to the list of projects to load in tmux
#
function _add_curr_dir_to_projects() {
    local PROJNAME=$1

    #
    # Check if we already have the dir for this project cached.
    #
    if [[ -f ~/.projecthist ]]; then
        if [[ -n "$(grep "^$PROJNAME:" ~/.projecthist | cut -d: -f2)" ]]; then
            echo "$PROJNAME is already a project"
            return 1
        fi
    fi

    echo "$PROJNAME:$(pwd)" >> ~/.projecthist
    return 0
}

#
# Find the directory for a project from its name. Just returns the first path
# to a directory with the same name as the project.
#
function dir_for_project() {
    local PROJNAME=$1
    local PROJDIR

    #
    # Find project in project directory
    #
    if [[ -f ~/.projecthist ]]; then
        PROJDIR=$(grep "^$PROJNAME:" ~/.projecthist | head -1 | cut -d: -f2)
    fi

    echo "$PROJDIR"
}

#
# Find dir by traversing upwards
#
function reverse_find_dir() {
    local dir_to_find=$1
    local start_path=`pwd`    # Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		if [ -d ".git" ]; then
			local found_git=1
			break
		fi
		cd ..
	done

	if [[ -n "$found_git" ]]; then
        pwd
	fi

    cd $start_path  # Reset cwd to where we started.
}

#
# cd to root of current git working dir
#
function cd_git_root() {
    local root=`reverse_find_dir .git`
    if [[ -n "$root" ]]; then
        cd $root
    else
        echo "Could not find a .git dir"
    fi
}


#
# Check if we have an active python.
#
function is_python_active() {
    if [[ $(type -w deactivate) == "deactivate: function" ]]; then
        return 0
    fi

    return 1
}

function find_python_venv_activate_script() {
    local curr_dir=$1
    [[ -z $1 ]] && curr_dir=.

    local probe

    # unix style activation available?
    probe="$curr_dir/venv/bin/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi

    # windows style activation available?
    probe="$curr_dir/venv/Scripts/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi

    # LIME embedded style activation available?
    probe="$curr_dir/Python34/Scripts/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi
}

function dir_has_python_venv() {
    if [[ -n $(find_python_venv_activate_script) ]]; then
        return 0
    fi

    return 1
}

function activate_python() {
    local new_dir=$1
    [[ -z $1 ]] && new_dir=.

    local activate_script=`find_python_venv_activate_script $new_dir`

    if [ -z $activate_script ]; then
        return 1
    fi

    if is_python_active; then
        deactivate
        unset deactivate
    fi

    export VIRTUAL_ENV_DISABLE_PROMPT='1'
    source ${activate_script}
}

#
# Function for recursively find a venv in parent dirs and activate it
#
function av() {
    local start_path=`pwd`	# Remember where we started so we can reset

    while [[ "`pwd`" != "/" ]];
    do
        local activate_script=`find_python_venv_activate_script`
        if [ -n "$activate_script" ]; then
            activate_python
            local found_venv=1
            break
        fi
        cd ..
    done

    if [[ -z "$found_venv" ]]; then
        echo "Could not find a python to activate!"
    fi

    cd $start_path  # Reset cwd to where we started.
}

#
# Function to cd to a directory and automatically activate any
# Python virtual environment in the target dir.
#
function cd() {
    builtin cd $1 && activate_python
}


# }}}

# {{{ Tmux Stuff

function tms() {
    local DIR=$1

    if [[ -z $DIR ]]; then
        echo "Usage: tms <directory>"
        return 1
    fi

    local SESSNAME=$(basename $DIR)

    if [[ -n "$TMUX" ]]; then
        tmux new -s $SESSNAME -d -n 'main' -c $DIR:A &> /dev/null
        tmux switch-client -t $SESSNAME
    else
        tmux new -A -s $SESSNAME -n 'main' -c $DIR:A
    fi
}

# }}}

# }}}

# {{{ Aliases

# {{{ General shell stuff
# Tell tmux to always expect 256 colors
alias tmux='tmux -2'

# attach to an exisiting tmux session
alias tma='tmux attach'

# Reload profile after making changes
alias zr!='echo "Reloading .zshrc..." && source ~/.zshrc'

# Quickly cd to root of current .git dir
alias cdg='cd_git_root'

# Remove all merged branches in git
alias gitprune='git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d'

# }}}

# }}}

# {{{ Customized prompt
setopt PROMPT_SUBST

# {{{ Venv status
function venv_prompt_info() {
    if is_python_active; then
        if [[ ! ( -d $VIRTUAL_ENV ) ]]; then
            echo "%{$fg[red]%}[  venv is gone]%{$reset_color%}"
            return
        fi

        local venv_path=`basename "$VIRTUAL_ENV/.."(:A)`
        echo "%{$fg[yellow]%}[ $venv_path]%{$reset_color%}"
    fi
}
# }}}

# {{{ Git status functions
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[red]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}]"

# get the name of the branch we are on
function git_prompt_info() {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
function parse_git_dirty() {
    local STATUS=''
    local FLAGS
    FLAGS=('--porcelain')

    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        FLAGS+='--untracked-files=no'
    fi

    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)

    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}
# }}}

# {{{ Vim mode status
function zle-keymap-select {
    case "${KEYMAP}" in
        main|viins)
            vim_mode="I"
            ;;
        vicmd)
            vim_mode="N"
            ;;
        visual)
            vim_mode="V"
            ;;
        *)
            vim_mode="?"
            ;;
    esac

    zle reset-prompt
}

function zle-line-finish {
    vim_mode="I"
}

vim_mode="I"

zle -N zle-line-finish
zle -N zle-keymap-select

# 
# Handle C-c in CMD mode, which will not trigger a recalculation of vim mode.
# This would leave the prompt displayed afterward to indicate command mode
#
function TRAPINT {
    vim_mode='I'
    return $(( 128 + $1))
}

# }}}

function display_main_prompt {
    local curr_time="%{$fg[green]%}%*"
    local curr_dir="%{$reset_color%}%~"
    local git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'
    local venv_info='$(venv_prompt_info)'
    local vim_info='%{$fg[green]%}[ ${vim_mode}]%{$reset_color%}'

    echo "%{$fg[blue]%}┌── ${curr_time} ${curr_dir} ${git_branch} ${venv_info}
%{$fg[blue]%}└─%{$reset_color%}$ "
}

function display_right_prompt {
    local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"

    echo "${return_code}"
}

export PROMPT="$(display_main_prompt)"
export RPS1="$(display_right_prompt)"
# }}}

# {{{ Load OS specific settings
if [[ -n $(uname | egrep -i 'darwin') ]]; then
    source ~/.zshrc.darwin
elif [[ -n $(uname | egrep -i 'cygwin') ]]; then
    source ~/.zshrc.cygwin
fi
# }}}

# FZF in zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# CTRL-P to edit a file in vim from fzf

BASE16_SHELL=$HOME/.config/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_solarized-light
