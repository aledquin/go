#!/usr/bin/env bash

# store if we're sourced or not in a variable
function setSourcedScript
{
    (return 0 2>/dev/null) && SOURCED=1 || SOURCED=0    
}

function exitIfNotSourced 
{
  [[ "$SOURCED" != "0" ]] || exit;
}

function showHelp
{
    DOUSAGE='Usage: go {help|list|create|delete|save|update|edit|remove_all} ?alias? ?path? ?regex?'
    echo $DOUSAGE
}

function checkInput 
{
if [ -z "$1" ]
then
  showHelp
  exitIfNotSourced;
  exitSourcedScript;
fi
}

function exitSourcedScript 
{
    return;
}


#==================================================


function setPortfolioName
{
    DEFAULT_PORTFOLIO_NAME="$HOME\/env\/dir_map.$USER"
    PORTFOLIO_DIRS=
    : ${PORTFOLIO_DIRS:=$DEFAULT_PORTFOLIO_NAME}
}

function existsPortfolio
{
    if [ ! -f $PORTFOLIO_DIRS ]
    then 
        mkdir `dirname $PORTFOLIO_DIRS`
        touch $PORTFOLIO_DIRS
    fi
}

#==================================================

function setGOROOT
{
    GOROOT=
    : ${GOROOT:=$HOME}
}


#==================================================

function runEditor
{
    EDITOR=
    : ${EDITOR:=nano}
    $EDITOR $PORTFOLIO_DIRS
    exitSourcedScript;
}

#==================================================


function displayList
{
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g'
    exitSourcedScript;
}

#==================================================

function removeAll
{
    rm -f ${PORTFOLIO_DIRS}
    exitSourcedScript;
}

#==================================================

exitSourcedScript