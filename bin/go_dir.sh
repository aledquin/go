#!/bin/bash
argv=($@)

function printFunctionName
{
        # printf "${FUNCNAME[1]}\n"
        return
}

# store if we're sourced or not in a variable
function setSourcedScript {
    printFunctionName
    (return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
}

function exitIfNotSourced {
    printFunctionName
    [[ "$SOURCED" != "0" ]] || exit
}

#==================================================

function setHelp {
    printFunctionName
    DOUSAGE='Usage: go {help|list|create|delete|save|update|alias|exists|edit|remove_all} ?alias? ?KEYWORD1[ KEYWORD2]...?'
}

function usageHelp {
    printFunctionName
    setHelp
    echo "You will need to setup an alias that sources this script. As:"
    echo "   > alias go 'source ~/bin/go_dir.sh'"
    echo "=========================================================="
    echo "$DOUSAGE"
    echo "=========================================================="
    echo "DESCRIPTION "
    echo "   'go' is a tool that saves paths you want to go again. It has the option to save paths with their own aliases. When you save a new alias, it gets added to complete option: 'go <TAB>' and it will show the options.\n   It will look directly to you GOROOT path if you use a keyword that is not an alias or an option. It uses the first two strings as argument for regex searching for directories. "
    echo "Directories are getting saved in: $PORTFOLIO_DIRS"
    echo "If you want to redefine it, use a env var\n: > setenv PORTFOLIO_DIRS <new_path>"
    echo "    "
    echo "=========================================================="
    echo "COMMANDS"

    echo "   go list --> Display list of alias directories saved"

    echo "   go create <alias_name> <alias_path> --> save a new alias"
    echo "   go save   <alias_name> <alias_path> --> save a new alias"

    echo "   go update <alias_name> <alias_path> --> updaters an old alias"

    echo "   go remove_all     --> Delete file that contains alias paths."
    echo "   go delete <alias_name> --> delete an alias"

    echo "   go help --> Display this message"
    echo "   go edit --> Open to edit $PORTFOLIO_DIRS"

    echo "   go KEYWORD1     --> go to search in $GOROOT for a directory that is called KEYWORD1."
    echo "   go KEYWORD1 KEYWORD2 --> go to search in $GOROOT using both keywords to find it."
    echo "    "
    echo "=========================================================="
    echo "EXAMPLES"
    echo "   > alias go 'source ~/bin/go_dir.csh'"
    echo "   > go create home '$HOME' => Adds name 'home' to file '$PORTFOLIO_DIRS'."
    echo "   > go list                => List all the created names. 'home' should show up."
    echo "   > go home                => This will cd to '$HOME' ."
    echo "   > go remove_all          => Deletes all names from file '$PORTFOLIO_DIRS'."
    echo "    "
    echo "=========================================================="
    echo Created by: alvaro.
}

function chooseMode {
    printFunctionName
    if [ ${#argv[@]} -gt 3 ]; then return; fi
    optionMode=${argv[0]}
    optionList="-list -save -update -delete -remove_all -edit -help"
    case $optionMode in
    *list)
        displayList
        ;;
    *save)
        saveAlias
        ;;
    *create)
        saveAlias
        ;;
    *update)
        updateAlias
        ;;
    *delete)
        deleteAlias
        ;;
    *exists)
        existsAlias
        ;;
    *remove_all)
        removeAll
        ;;
    *help)
        usageHelp
        ;;
    *edit)
        runEditor
        ;;
    *)
        goDirectory
        ;;
    esac
    return
}

#==================================================

function checkInput {
    printFunctionName
    if [ ${#argv[@]} -lt 1 ]; then
        usageHelp
        exitIfNotSourced
        exitSourcedScript
    fi
}

#==================================================

function exitSourcedScript {
    printFunctionName
    return
}

#==================================================

function setPortfolioName {
    printFunctionName
    DEFAULT_PORTFOLIO_NAME="$HOME/env/dir_map.$USER"
    PORTFOLIO_DIRS=
    : ${PORTFOLIO_DIRS:=$DEFAULT_PORTFOLIO_NAME}
    existsPortfolio
}

function existsPortfolio {
    printFunctionName
    if [ ! -f $PORTFOLIO_DIRS ]; then
        mkdir -p "$(dirname $PORTFOLIO_DIRS)"
        touch $PORTFOLIO_DIRS
    fi
}

function isEmptyPortfolio {
    printFunctionName
    if [ -s $PORTFOLIO_DIRS ]; then
        aliasListEmpty=true
    else
        aliasListEmpty=false
    fi
}

#==================================================

function setGOROOT {
    printFunctionName
    GOROOT=
    : ${GOROOT:=$HOME}
}

#==================================================

function runEditor {
    printFunctionName
    EDITOR=
    : ${EDITOR:=nano}
    $EDITOR $PORTFOLIO_DIRS
    exitSourcedScript
}

#==================================================

function displayList {
    printFunctionName
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g'
    exitSourcedScript
}

#==================================================

function getAliasList {
    printFunctionName
    aliasList=$(cat $PORTFOLIO_DIRS | cut -d ":" -f1)
    return
}

function getAliasInfo {
    printFunctionName
    aliasName=${argv[1]}
    if [ ${#argv[@]} -eq 3 ]; then
        aliasPath=$(realpath ${argv[2]})
        echo ${argv[2]}
        echo $aliasPath
    fi
    if [ ! -d $aliasPath ]; then
        aliasPath=$(dirname $aliasPath)
    fi

}

function existsAlias {
    printFunctionName
    getAliasInfo
    isInFile=$(cat $PORTFOLIO_DIRS | grep -c "$aliasName")
    if [ $isInFile -eq 0 ]; then
        aliasExists=false
    else
        aliasExists=true
    fi
    if [ $optionMode == "exists" ]; then
        echo $aliasExists
    fi

}

function saveAlias {
    printFunctionName
    existsAlias
    if [ "$aliasExists" == "true" ]; then
        echo "The current alias $aliasName exists."
        echo -e "If you want to update use: \n \t go update <aliasName> <newDir>"
        exitSourcedScript
    else
        echo creating alias "$aliasName:::${aliasPath}"
        echo -e "$aliasName:::${aliasPath}" >>${PORTFOLIO_DIRS}
    fi
}

function updateAlias {
    printFunctionName
    existsAlias
    if [ "$aliasExists" == "true" ]; then
        sed -i "/${aliasName}/c\ " ${PORTFOLIO_DIRS}
        sed -i "/^${aliasName}/d" ${PORTFOLIO_DIRS}
        sed -i "/^ /d" ${PORTFOLIO_DIRS}

        echo -e "$aliasName:::${aliasPath}" >>${PORTFOLIO_DIRS}
    else
        echo "Alias not found"
    fi
}

function deleteAlias {
    printFunctionName
    existsAlias
    if [$aliasExists]; then
        sed -i "/${aliasName}/c\ " ${PORTFOLIO_DIRS}
    fi
    return
}
#==================================================

function removeAll {
    printFunctionName
    rm -f ${PORTFOLIO_DIRS}
    exitSourcedScript
}

#==================================================

function goDirectory {
    printFunctionName
    aliasName=${argv[0]}
    Substring=${argv[1]}

    existsAlias
    if [ $aliasExists ]; then
        getAliasPath
        cd $(find $aliasPath -type d | grep ".*$SubString" -m 1)
    else

        if [ $# ] >1; then
            cd $(find $GOROOT -type d | grep "${aliasName}.*${SubString}" -m 1)
        else
            cd $(find $GOROOT -type d -name "*${aliasName}" | head -1)
        fi
    fi
}

function getAliasPath {
    printFunctionName
    aliasName=${argv[0]}
    for aliasDBLine in $(cat $PORTFOLIO_DIRS); do
        aliasDBName=$(echo ${aliasDBLine} | cut -d ":" -f1)
        if [[ "$aliasDBName" =~ "$aliasName" ]]; then
            aliasPath=$(echo $aliasDBLine | cut -d ":" -f4-)
            aliasPath=$(eval echo $aliasPath)
            return
        fi
    done
}

function main {
    setSourcedScript
    setHelp
    checkInput
    setPortfolioName
    chooseMode
    getAliasList
    complete -W "$aliasList $optionList" go
    exitSourcedScript
}

main