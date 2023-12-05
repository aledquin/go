
function Messaging.eprint {
    echo -ne "\e[0;31mError:\e[0m "
    echo $@
    return 1
}

function Messaging.dprint {
    local _MESSAGE_="$@"
    DEBUG=${DEBUG:=0}
    if [ $DEBUG -ne "0" ]; then
        echo "${_MESSAGE_}"
    fi
}

function Messaging.vprint {
    local _MESSAGE_="$@"
    VERBOSITY=${VERBOSITY:=0}
    if [ $VERBOSITY -ne "0" ]; then
        echo "${_MESSAGE_}"
    fi
}

function Messaging.printFunctionName
{
    set_debug $@
    dprint "${FUNCNAME[@]:1:DEBUG}"
}