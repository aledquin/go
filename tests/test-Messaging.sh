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
    Package.import Messaging
    Package.import Utils
}

function counter {
    counter=${counter:=0}
    counter=$((counter + 1))
}

function _test {
    local _fargs=($@)
    Messaging.printFunctionName
    counter

    functionName=$1
    ret_val=$3

    functionArgs=${_fargs[3]}

    $functionName $functionArgs
    varReturn="${!2}"

    debug.print "$functionName $functionArgs"
    debug.print "variable:$2"
    debug.print "ret_val: $varReturn"

    if [[ "$varReturn" =~ "$ret_val" ]]; then
        echo ">$counter> PASSED:$functionName"
    else
        echo ">$counter> FAILED:$functionName --> $ret_val not found in $varReturn"
    fi
}

_setup
_requirements
_test eprint "is it red" "is it red" 
