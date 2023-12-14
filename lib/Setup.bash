Package.provide Setup || echo "Package tool not supported"

DEBUG=${DEBUG:=0}         && [[ $DEBUG -gt 0 ]]     && set -o errtrace
VERBOSITY=${VERBOSITY:=0} && [[ $VERBOSITY -gt 0 ]] && set -o verbose

function Setup.set_debug {
    local _fargs=($@)
    (Setup.is_integer "${_fargs[0]}") && DEBUG=${_fargs[0]}
}

function Setup.is_integer {
    Messaging.printFunctionName
    local _fargs=($@)
    if ! [[ "$_fargs" =~ ^-?[0-9.]+$ ]]; then
        echo "$_fargs is not an integer"
        return 1
    fi
    echo "$_fargs is integer"
    return 0
}

function Setup.debug_cmd {
    [[ $DEBUG -gt 0 ]] && eval $@
}
