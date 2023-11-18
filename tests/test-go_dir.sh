#!/bin/bash
argv=($@)
root=$(realpath $(dirname $0)/../)
RealBin="$root/bin"
RealScript="go_dir.sh"
DEBUG=1
source $RealBin/$RealScript

setSourcedScript
echo SOURCED=$SOURCED

function _test {
    functionName=$1
    ret_val=$3
    
    $functionName
    varReturn="${!2}"
    echo $2
    echo $varReturn
    dprint "$ret_val:$varReturn"
    if [[ "$varReturn" =~ "$ret_val" ]]; then 
        echo "> > PASSED:$functionName"
    else 
        echo "> > FAILED:$functionName --> $ret_val not found in $varReturn"
    fi

}



_test setHelp \
    DOUSAGE "Usage"

_test setPortfolioName \
    PORTFOLIO_DIRS "env/dir_map"

_test setGOROOT \
    GOROOT "$USER"

_test setAliasList \
    aliasList "home"

