#!/bin/bash
argv=($@)
root=$(realpath $(dirname $0)/../)
RealBin="$root/bin"
RealScript="go_dir.sh"

source $RealBin/$RealScript

setSourcedScript
dprint SOURCED=$SOURCED

function _test {
    counter=${counter:=0}
    counter=$((counter+1))
    _fargs=($@)
    functionName=$1
    ret_val=$3
    functionArgs=${_fargs[3]}
    $functionName $functionArgs
    varReturn="${!2}"
    dprint "variable:$2"
    dprint "ret_val: $varReturn"
    if [[ "$varReturn" =~ "$ret_val" ]]; then
        echo ">$counter> PASSED:$functionName"
    else
        echo ">$counter> FAILED:$functionName --> $ret_val not found in $varReturn"
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

_test setOptionList \
optionList "-list"
_test setOptionList \
optionList "-save"
_test setOptionList \
optionList "-help"


_test setOptionExists \
optionExists "0" \
fakeOption


_test setOptionExists \
optionExists "1" \
"-list"

DEBUG=1

