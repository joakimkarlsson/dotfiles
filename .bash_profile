# Make separately installed vim come first in path
export PATH=/c/vim/bin:$PATH

export JAVA_HOME=/c/Program\ Files/Java/jre1.8.0_20

# Common bash operation aliases
alias ll="ls -lp --color=auto"
alias v="gvim"
alias lwatch="limefu test unit --watch"
alias lflake="limefu test flake"
alias lall="limefu test unit --all && \
    limefu test functional && \
    limefu test flake && \
    limefu test e2e"
alias grephist="git rev-list --all | xargs git grep"
alias sup="cmd //c /c/src/limetng/setup"

#
# Function for recursively find a venv in parent dirs and activate it
#
function ap() {
	start_path=`pwd`	# Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		echo "Searching in `pwd` for a python folder..."
		if [ -f "Python34/Scripts/activate" ]; then
			echo "found python, activating..."
			source Python34/Scripts/activate
			local found_python=1
			break
		fi
		cd ..
	done

	if [[ -z "$found_python" ]]; then
		echo "Could not find a python directory!"
	fi

	cd $start_path  # Reset cwd to where we started.
}

function _update_ps1 {
    local error_level=$?
    local curr_python=`which python`
    export PYTHONIOENCODING=utf-8
    export PS1="$(/c/Python33/python.exe ~/bash_prompt.py $error_level $curr_python 2> /dev/null)"
}

export PROMPT_COMMAND="_update_ps1"
