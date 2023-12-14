#!/bin/bash
argv=($@)

function _setup {
    root=$(realpath $(dirname $0)/../)
    export root

    BinBin="$root/bin"
    local LibBin="$root/lib"
    RealScript="Messaging.bash"

    source $LibBin/Package.bash
}

function _requirements {
    Package.import Setup
    Package.import Messaging
    Package.import Utils

    Package.get_function eprint dprint vprint
}

function counter {
    counter=${counter:=0}
    counter=$((counter + 1))
}

function _test {
    printFunctionName
    counter

    functionName=$1
    ret_val=$3

    _fargs=($@)
    functionArgs=${_fargs[3]}

    $functionName $functionArgs
    varReturn="${!2}"

    dprint "$functionName $functionArgs"
    dprint "variable:$2"
    dprint "ret_val: $varReturn"

    if [[ "$varReturn" =~ "$ret_val" ]]; then
        echo ">$counter> PASSED:$functionName"
    else
        echo ">$counter> FAILED:$functionName --> $ret_val not found in $varReturn"
    fi
}

_setup
_requirements
eprint is it red
