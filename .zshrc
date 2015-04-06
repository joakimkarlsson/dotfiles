# The following lines were added by compinstall
zstyle :compinstall filename '/home/jkr/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#
# Load $fg & co with color codes
#
autoload -U colors && colors

#
# Check if we have an active python.
#
function is_python_active() {
    if [[ $(type -w deactivate) == "deactivate: function" ]]; then
        return 0
    fi

    return 1
}

function __reachable_python_activate_script() {
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

function activate_python() {
    local new_dir=$1
    [[ -z $1 ]] && new_dir=.

    local activate_script=`__reachable_python_activate_script $new_dir`

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
        local activate_script=`__reachable_python_activate_script`
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
# Customized prompt
#
setopt PROMPT_SUBST

function venv_prompt_info() {
    if is_python_active; then
        echo "%{$fg_bold[yellow]%}🐍%{$reset_color%}"
    fi
}

#
# Git status functions
#
ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

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

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local curr_time="%{$fg[green]%}%*"
local curr_dir="%{$reset_color%}%d"
local git_branch='%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}'
local venv_info='$(venv_prompt_info)'

export PROMPT="%{$fg[blue]%}╭── ${curr_time} ${curr_dir} ${git_branch} ${venv_info}
%{$fg[blue]%}╰─%{$reset_color%}$ "
export RPS1="${return_code}"
