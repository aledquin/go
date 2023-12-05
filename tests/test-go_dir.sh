#!/bin/bash
argv=($@)
root=$(realpath $(dirname $0)/../)
RealBin="$root/bin"
RealScript="go_dir.sh"

source $root/sharedlib/lib.bash

source $RealBin/$RealScript

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



_test setSourcedScript \
SOURCED "1"

_test setHelp \
DOUSAGE "Usage"

_test setGOROOT \
GOROOT "$USER"

_test setPortfolioName \
PORTFOLIO_DIRS "env/dir_map"

_test isEmptyPortfolio \
aliasListEmpty "false"

_test setOptionList \
optionList "list"
_test setOptionList \
optionList "save"
_test setOptionList \
optionList "help"

_test setOptionExists \
optionExists "false" \
fakeOption

_test setOptionExists \
optionExists "true" \
"list"

_test setAliasName \
aliasName "home" \
"home"

_test setAliasExists \
aliasExists "true" 
_test setAliasExists \
aliasExists "false" \
"fakeAlias" 

_test setAliasList \
aliasList "home"

_test setAliasPath \
aliasPath $root \
$root

_test getAliasPath \
aliasPath "/home/" \
"home" 

sd save newAlias .
sd newAlias
sd exists newAlias
sd delete newAlias
sd . 
sd home go
sd create origin /
sd delete origin
