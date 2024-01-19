Package.provide Setup || echo "Package tool not supported"


# set a value to required variables
DEBUG=${DEBUG:=0}         && [[ $DEBUG -gt 0 ]]     && set -o errtrace
VERBOSITY=${VERBOSITY:=0} && [[ $VERBOSITY -gt 0 ]] && set -o verbose

function Setup.set_debug {
    local _fargs=($@)
    (Setup.is_integer "${_fargs[0]}") && DEBUG=${_fargs[0]}
}

function Setup.dependency_check {

    return
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
    [[ $DEBUG -gt 0 ]] && eval $@ || echo $@
}



function handle_exit() {
    echo exit call
    return
   Add cleanup code here
   exit with an appropriate status code
}

#  trap <HANDLER_FXN> <LIST OF SIGNALS TO TRAP>
trap handle_exit 0 SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM