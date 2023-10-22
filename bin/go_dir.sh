#!/bin/bash
argv=("$@")

function printFunctionName
{
        printf "${FUNCNAME[1]}\n"
}

# store if we're sourced or not in a variable
function setSourcedScript
{
    printFunctionName
    (return 0 2>/dev/null) && SOURCED=1 || SOURCED=0    
}

function exitIfNotSourced 
{
    printFunctionName
  [[ "$SOURCED" != "0" ]] || exit;
}

#==================================================

function setHelp
{
    printFunctionName
    DOUSAGE='Usage: go {help|list|create|delete|save|update|edit|remove_all} ?alias? ?path? ?regex?'
}

function usageHelp
{
    printFunctionName
    setHelp
    echo $DOUSAGE
}

#==================================================

function checkInput 
{
    printFunctionName
    if [ ${#argv[@]} -lt 1 ]
    then
        usageHelp
        exitIfNotSourced;
        exitSourcedScript;
    fi
}

#==================================================

function exitSourcedScript 
{
    printFunctionName
    return;
}


#==================================================


function setPortfolioName
{
    printFunctionName
    DEFAULT_PORTFOLIO_NAME="$HOME/env/dir_map.$USER"
    PORTFOLIO_DIRS=
    : ${PORTFOLIO_DIRS:=$DEFAULT_PORTFOLIO_NAME}
    existsPortfolio
}

function existsPortfolio
{
    printFunctionName
    if [ ! -f $PORTFOLIO_DIRS ]
    then 
        mkdir -P "$(dirname $PORTFOLIO_DIRS)"
        return
        touch $PORTFOLIO_DIRS
    fi
}

function isEmptyPortfolio
{
    printFunctionName
    if [ -s $PORTFOLIO_DIRS ]
    then
        aliasListEmpty=true
    else
        aliasListEmpty=false
    fi
}

#==================================================

function setGOROOT
{
    printFunctionName
    GOROOT=
    : ${GOROOT:=$HOME}
}


#==================================================

function runEditor
{
    printFunctionName
    EDITOR=
    : ${EDITOR:=nano}
    $EDITOR $PORTFOLIO_DIRS
    exitSourcedScript;
}

#==================================================

function displayList
{
    printFunctionName
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g'
    exitSourcedScript;
}

#==================================================

function getAliasList
{
    printFunctionName
    aliasList=`cat $PORTFOLIO_DIRS | cut -d ":" -f1`
}

function getAliasInfo
{
    printFunctionName
    aliasName=$2
    if [ ! -z $3 ]; then aliasPath=`realpath $3`; fi
    if [ ! -d $aliasPath ]
    then 
        aliasPath=$(dirname $aliasPath)
    fi

}

function existsAlias
{   
    printFunctionName
    getAliasInfo
    isInFile=`cat $PORTFOLIO_DIRS | grep -c "$aliasName"`
    if [ $isInFile -eq 0 ]; then
        aliasExists=false
    else
        aliasExists=true
    fi
}

function saveAlias
{
    printFunctionName
    existsAlias
    if [$aliasExists]
    then 
        updateAlias
    else
        echo "${aliasName}:::${aliasPath}" >> ${PORTFOLIO_DIRS}
    fi
}

function updateAlias
{
    printFunctionName
    sed -i "/${aliasName}/c\${aliasName}\:\:\:${aliasPath}" ${PORTFOLIO_DIRS}
}


function deleteAlias
{
    printFunctionName
    existsAlias
    if [$aliasExists]
    then 
         sed -i "/${aliasName}/c\ " ${PORTFOLIO_DIRS}
    fi
    exitSourcedScript;
}
#==================================================

function removeAll
{
    printFunctionName
    rm -f ${PORTFOLIO_DIRS}
    exitSourcedScript;
}

#==================================================

function chooseMode
{
    printFunctionName
    if [ $# > 3 ]; then exitSourcedScript; fi
    optionMode=$1
    case $optionMode in
        list)
        displayList
        ;;
        save)
        saveAlias
        ;;
        create)
        saveAlias
        ;;
        update)
        saveAlias
        ;;
        delete)
        deleteAlias
        ;;
        remove_all)
        removeAll
        ;;
        help)
        usageHelp
        ;;
        edit)
        runEditor
        ;;
        *)
        goDirectory
        ;;
    esac
    return;
}

function goDirectory
{
    printFunctionName
    aliasName=$1
    Substring=$2

    existsAlias
    if [ $aliasExists ]
    then 
        getAliasPath
        cd `find $aliasPath -type d | grep ".*$SubString" -m 1`
    else

        if [ $#  > 1 ]
        then
            cd `find $GOROOT -type d | grep "${aliasName}.*${SubString}" -m 1`
        else
            cd `find $GOROOT -type d -name "*${aliasName}" | head -1`
        fi
    fi
}

function getAliasPath
{
    printFunctionName
    for aliasDBLine in `cat $PORTFOLIO_DIRS`
    do
        aliasDBName=`echo ${aliasDBLine} | cut -d ":" -f1`
        if [ $aliasDBName =~ $aliasName ]
        then
            aliasPath=`echo $aliasDBLine | cut -d ":" -f4-`
            aliasPath=`eval echo $aliasPath`
            return
        fi
    done
}

setSourcedScript
printf "Source script = $SOURCED\n"
setHelp
checkInput
setPortfolioName
chooseMode
exitSourcedScript;