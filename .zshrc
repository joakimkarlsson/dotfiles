# vim:foldmethod=marker

#
# Add custom directory for my functions to fpath
#
fpath=($fpath ~/.zshfunctions)

# {{{ The following lines were added by compinstall
zstyle :compinstall filename '/home/jkr/.zshrc'

autoload -Uz compinit
compinit
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

# }}}

# {{{ Aliases

# {{{ Aliases to make some native windows applications play nice with
# a standard terminal. Uses https://github.com/rprichard/winpty
alias lf='console.exe limefu'
alias ipython='EDITOR=$(cygpath -w /usr/bin/vim) console.exe ipython3'
alias node="console.exe node"
alias nt="console.exe nosetests"
alias devpi="console.exe devpi"
# }}}

# {{{ LIME specific stuff
alias lall="console.exe limefu test flake && \
    console.exe limefu test unit --all&& \
    console.exe limefu test functional && \
    console.exe limefu test e2e"
alias sup="pushd ~/src/limetng && cmd /c setup.bat; popd"
alias venv34="console.exe /cygdrive/c/Python34/Scripts/virtualenv venv"
# }}}

# {{{ General shell stuff
# Tell tmux to always expect 256 colors
alias tmux='tmux -2'

# attach to an exisiting tmux session
alias tma='tmux attach'

# Kill a native window process from cygwin terminal
alias killw='taskkill /F /PID'

# Standard shell shortcuts
alias ll='ls -l --color'
alias la='ls -lA --color'

# Reload profile after making changes
alias zshrel='echo "Reloading .zshrc..." && source ~/.zshrc'

# Quickly cd to root of current .git dir
alias cdg='cd_git_root'

# }}}

# }}}

# {{{ Behavior
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Remember history
HISTSIZE=1000
HISTFILE=~/.history
SAVEHIST=1000
# }}}

# {{{ Functions

#
# Find the directory for a project from its name. Just returns the first path
# to a directory with the same name as the project.
#
function dir_for_project() {
    local PROJNAME=$1
    local PROJDIR

    #
    # Check if we already have the dir for this project cached.
    #
    if [[ -f ~/.projecthist ]]; then
        PROJDIR=$(grep "^$PROJNAME:" ~/.projecthist | cut -d: -f2)
    fi

    if [[ -n "$PROJDIR" ]]; then
        echo "$PROJDIR"
        return
    fi

    #
    # Attempt to find the project directory
    #
    PROJDIR=$(find -L ~/src -maxdepth 4 -type d -iname $PROJNAME -print -quit)

    #
    # Cache the directory if we found it.
    #
    if [[ -n $PROJDIR ]]; then
        echo "$PROJNAME:$PROJDIR" >> ~/.projecthist
        echo $PROJDIR
    fi
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


# {{{ Python Stuff
#
# Source install another python package into the current python environment.
#
function srcinst() {
    local PROJNAME=$1
    local PROJDIR=$(dir_for_project $PROJNAME)

    echo "Uninstalling existing..."
    pip freeze | grep -i "$PROJNAME" &> /dev/null
    if [ $? = 0 ]; then
        pip uninstall $PROJNAME
    fi

    echo "Installing from $PROJDIR..."
    pushd $PROJDIR
    pip install -e .
    popd
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
# }}}

# {{{ Tmux Stuff

#
# Generate the tmux status-right information
#
function _tmux_status_right() {
     date +"%a %Y-%m-%d %R"
}

#
# Start, or attach to, a tmux sesssion with a window for
# the desired project.
#

function _default_tmux_pane_layout() {
    local WORKDIR=$1
    echo "Setting up default layout. Directory: $WORKDIR"

    tmux split-window -c $WORKDIR
    tmux send-keys -t 0 'av && vim' C-m # vim with activated python
    tmux resize-pane -t 0 -y 40
    tmux select-pane -t 1
}


function tms() {
    local SESSIONNAME="LIME"
    local PROJNAME=$1

    #
    # Default to 'limetng' if no project is provided
    #
    if [ -z "$PROJNAME" ]; then
        PROJNAME="limetng"
    fi

    local PROJDIR=$(dir_for_project $PROJNAME)
    if [ -z "$PROJDIR" ]; then
        echo "Could not find a directory for $PROJNAME"
        return 1
    fi

    #
    # See if we already have a seesion. If not, create one
    #
    tmux has-session -t $SESSIONNAME &> /dev/null
    if [ $? != 0 ]; then
        echo "Session $SESSIONNAME not found. Creating it..."
        tmux new-session -s $SESSIONNAME -d -n $PROJNAME -c $PROJDIR
        _default_tmux_pane_layout $PROJDIR
    else
        #
        # Check if we already have a window for the project
        # If not, create a new window. Otherwise, select the exisiting one.
        tmux list-windows -t LIME | grep "^[[:digit:]]\+: $PROJNAME" &> /dev/null
        if [ $? != 0 ]; then
            tmux new-window -n $PROJNAME -c $PROJDIR
            _default_tmux_pane_layout $PROJDIR
        else
            tmux select-window -t $PROJNAME
        fi
    fi

    #
    # Attach to the session. If this fails because we're already attached,
    # fail silently.
    #
    tmux attach-session -t $SESSIONNAME &> /dev/null
}

# }}}

# {{{ LIME Stuff

function glp() {
    # gulp replacement for running gulp inside node_modules
    #
    if [[ (-d "$PWD/node_modules") && (-d "$PWD/node_modules/gulp") ]]; then
        console node node_modules/gulp/bin/gulp.js $*
    else
        echo "Cannot find a node_modules or a gulp directory!"
    fi
}

# }}}

# }}}

# {{{ Customized prompt
setopt PROMPT_SUBST

function venv_prompt_info() {
    if is_python_active; then
        echo "%{$fg_bold[yellow]%}🐍%{$reset_color%}"
    fi
}

# {{{ Git status functions
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
# }}}

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local curr_time="%{$fg[green]%}%*"
local curr_dir="%{$reset_color%}%~"
local git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'
local venv_info='$(venv_prompt_info)'

export PROMPT="%{$fg[blue]%}╭── ${curr_time} ${curr_dir} ${git_branch} ${venv_info}
%{$fg[blue]%}╰─%{$reset_color%}$ "
export RPS1="${return_code}"
# }}}
