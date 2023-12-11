
function Messaging.eprint {
    local _fargs=($@)
    local _MESSAGE_="${_fargs[@]}"
    _MESSAGE_="\e[0;31mError:\e[0m $_MESSAGE_"
    echo -e "$_MESSAGE_"
    return
}

function Messaging.dprint {
    local _fargs=($@)
    local _MESSAGE_="\e[0;32DEBUG:\e[0m ${_fargs[@]}"
    DEBUG=${DEBUG:=0}
    [[ $DEBUG -ne "0" ]] && echo "${_MESSAGE_}"
    reaturn
}

function Messaging.vprint {
    local _fargs=($@)
    local _MESSAGE_="${_fargs[@]}"
    VERBOSITY=${VERBOSITY:=0}
    [[ $VERBOSITY -ne "0" ]] && echo "${_MESSAGE_}"
}

function Messaging.printFunctionName
{
    local _fargs=($@)
    Setup.set_debug ${_fargs[0]}
    echo "${FUNCNAME[@]:1:DEBUG}"
}

function ansi_color {
    return
}


function Messaging {
    return

}