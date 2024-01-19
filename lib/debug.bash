
DEBUG=${DEBUG:=0}         && [[ $DEBUG -gt 0 ]]     && set -o errtrace
VERBOSITY=${VERBOSITY:=0} && [[ $VERBOSITY -gt 0 ]] && set -o verbose

function debug.set {
    local _fargs=($@)
    (is_integer "${_fargs[0]}") && DEBUG=${_fargs[0]}
}

function debug.cmd {
    [[ $DEBUG -gt 0 ]] && eval $@
}

function debug.print {
    local _fargs=($@)
    local _MESSAGE_="\e[0;32DEBUG:\e[0m ${_fargs[@]}"
    DEBUG=${DEBUG:=0}
    [[ $DEBUG -ne "0" ]] && echo "${_MESSAGE_}"
    return
}


