
function Messaging.eprint {
    local _MESSAGE_="$@"
    _MESSAGE_="\e[0;31mError:\e[0m $_MESSAGE_"
    echo -e "$_MESSAGE_"
}

function Messaging.dprint {
    local _MESSAGE_="$@"
    DEBUG=${DEBUG:=0}
    [[ $DEBUG -ne "0" ]] && echo "${_MESSAGE_}"
}

function Messaging.vprint {
    local _MESSAGE_="$@"
    VERBOSITY=${VERBOSITY:=0}
    [[ $VERBOSITY -ne "0" ]] && echo "${_MESSAGE_}"
}

function Messaging.printFunctionName
{
    Setup.set_debug $@
    dprint "${FUNCNAME[@]:1:DEBUG}"
}