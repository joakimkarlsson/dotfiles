# Make separately installed vim come first in path
export PATH=/c/Program\ Files\ \(x86\)/Vim/vim74:$PATH

# Common bash operation aliases
alias ll="ls -lp --color=auto"

#
# Function for recursively find a venv in parent dirs and activate it
#
function actvenv() {
	start_path=`pwd`	# Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		echo "Searching in `pwd` for a venv..."
		if [ -f "venv/Scripts/activate" ]; then
			echo "found a venv. activating..."
			source venv/Scripts/activate
			local found_venv=1
			break
		fi
		cd ..
	done

	if [[ -z "$found_venv" ]]; then
		echo "Could not find a venv directory!"
	fi

	cd $start_path  # Reset cwd to where we started.
}

function prompt {
    local color_pipe="\\[\e[31m\\]"
    local color_reset="\\[\e[0m\\]"
    local arc_down_right=$'\xe2\x95\xad'
    local arc_up_left=$'\xe2\x95\xb0'
    local horizontal=$'\xe2\x94\x80'

    local prefix="$color_pipe$arc_down_right$horizontal$horizontal\w$color_reset"
    local suffix="\n$color_pipe$arc_up_left$horizontal$color_reset$ "

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS="true"
    export PROMPT_COMMAND="__git_ps1 '$prefix' '$suffix'"
}
prompt
