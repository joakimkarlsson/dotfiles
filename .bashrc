# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Make user binaries available
[[ -d "${HOME}/bin" ]] && export PATH=$PATH:~/bin

# Use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

#
## ALIASES
#

# Aliases to make some native windows applications play nice with
# a standard terminal. Uses https://github.com/rprichard/winpty

alias limefu='console.exe limefu'
alias ipython='console.exe ipython'
alias ipython3='console.exe ipython3'
alias node="console.exe node"

# Tell tmux to always expect 256 colors
alias tmux='tmux -2'

alias ll='ls -l'

alias sup="pushd ~/src/limetng && cmd /c setup.bat; popd"

#
# Setting up 256 colors if possible
#
local256="$COLORTERM$XTERM_VERSION$ROXTERMID$KONSOLE_DBUS_SESSION"
if [ -n "$local256" ]; then
    case "$TERM" in
        'xterm') TERM="xterm-256color";;
        'screen') TERM="screen-256color";;
        'Eterm') TERM="Eterm-256color";;
    esac
    export TERM

    if [ -n "$TERMCAP" ] && [ "$TERM" = "screen-256color" ]; then
        TERMCAP=$(echo "$TERMCAP" | sed -e 's/Co#8/Co#256/g')
        export TERMCAP
    fi
fi
unset local256

#
# Display a more informational prompt.
#

function _update_ps1 {
    local error_level=$?
    local has_python=0
    [[ -n `__active_python` ]] && has_python=1
    export PS1="$(PYTHONIOENCODING=utf-8 python3 ~/bash_prompt.py $error_level $has_python 2>1 /dev/null)"
}

export PROMPT_COMMAND="_update_ps1"
