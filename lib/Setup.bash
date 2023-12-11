

DEBUG=${DEBUG:=0}         && [[ $DEBUG -gt 0 ]]      && set -o errtrace
VERBOSITY=${VERBOSITY:=0} && [[ $VERBOSITY -gt 0 ]]  && set -o verbose

function Setup.set_debug 
{
    local _fargs=($@)
    (Setup.is_integer "${_fargs[0]}") && DEBUG=${_fargs[0]}
}

function Setup.is_integer 
{
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