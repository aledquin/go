#!/bin/bash
argv=($@)
root=$(realpath $(dirname $0)/../)
RealBin="$root/bin"
RealScript="go_dir.sh"

source $root/lib/pkgIndex.bash



function counter {
    counter=${counter:=0}
    counter=$((counter+1))
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

eprint is it red