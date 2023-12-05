
function dprint {
    local _MESSAGE_="$@"
    DEBUG=${DEBUG:=0}
    if [ $DEBUG -ne "0" ]; then
        echo "${_MESSAGE_}"
    fi
}

function vprint {
    local _MESSAGE_="$@"
    VERBOSITY=${VERBOSITY:=0}
    if [ $VERBOSITY -ne "0" ]; then
        echo "${_MESSAGE_}"
    fi
}


function printFunctionName
{
    set_debug $@
    dprint "${FUNCNAME[@]:1:DEBUG}"
}

function set_debug {
    local _fargs=($@)
    (is_integer "${_fargs[0]}") && DEBUG=${_fargs[0]}
}

function incr {
    printFunctionName
    local _fargs=($@)
    local num_var=${_fargs[0]}
    local num_val=${!num_var:=0}
    local add_val=${_fargs[1]:=1}

    (is_integer $num_val)  &&  (is_integer $add_val)  || return 1
    
    num_val=$((num_val+add_val))
    eval  $num_var=$num_val
    dprint "$num_var = ${!num_var}"
    return 0
}

function _counter {
    incr _counter
}

function is_integer {
    printFunctionName
    local _fargs=($@)
    if ! [[ "$_fargs" =~ ^-?[0-9.]+$ ]]
        then
            dprint "$_fargs is not an integer"
            return 1
    fi
    dprint "$_fargs is integer"
    return 0
}

function copy_function {
  test -n "$(declare -f "$1")" || return 
  eval "${_/$1/$2}"
}

function rename {
  copy_function "$@" || return
  unset -f "$1"
}

