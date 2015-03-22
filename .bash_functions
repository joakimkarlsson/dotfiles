#
# Is a python virtualenv active?
#
function __active_python() {
    if [[ "$(type -t deactivate)" == "function" ]]; then
        echo `which python`
    fi
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

    local active_python=`__active_python`
    if [[ -n $active_python ]]; then
        deactivate
    fi

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
# Function for quickly navigating to root git directory
#
function cdgrt() {
    start_path=`pwd`    # Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		if [ -d ".git" ]; then
			local found_git=1
			break
		fi
		cd ..
	done

	if [[ -z "$found_git" ]]; then
		echo "Could not find a .git directory!"
        cd $start_path  # Reset cwd to where we started.
	fi
}

