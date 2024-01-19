#!/bin/bash
argv=($@)

function dprint {
    _MESSAGE_="$@"
    DEBUG=${DEBUG:=0}
    if [ $DEBUG -ne "0" ]; then
        echo "${_MESSAGE_}"
    fi
    unset _MESSAGE_
}


function printFunctionName
{
    dprint "${FUNCNAME[1]}"
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
    DOUSAGE='Usage:sd {help|list|create|delete|save|update|alias|exists|edit|remove_all} ?alias? ?KEYWORD1[ KEYWORD2]...?'
    return
}

function usageHelp {
    printFunctionName
    setHelp
    echo "You will need to setup an alias that sources this script. As:"
    echo "   > aliassd 'source ~/binsd_dir.sh'"
    echo "=========================================================="
    echo "$DOUSAGE"
    echo "=========================================================="
    echo "DESCRIPTION "
    echo "   sd' is a tool that saves paths you want tosd again. It has the option to save paths with their own aliases. When you save a new alias, it gets added to complete option: sd <TAB>' and it will show the options.\n   It will look directly to yousdROOT path if you use a keyword that is not an alias or an option. It uses the first two strings as argument for regex searching for directories. "
    echo "Directories are getting saved in: $PORTFOLIO_DIRS"
    echo "If you want to redefine it, use a env var\n: > setenv PORTFOLIO_DIRS <new_path>"
    echo "    "
    echo "=========================================================="
    echo "COMMANDS"
    
    echo "  sd list --> Display list of alias directories saved"
    
    echo "  sd create <alias_name> <alias_path> --> save a new alias"
    echo "  sd save   <alias_name> <alias_path> --> save a new alias"
    
    echo "  sd update <alias_name> <alias_path> --> updaters an old alias"
    
    echo "  sd remove_all     --> Delete file that contains alias paths."
    echo "  sd delete <alias_name> --> delete an alias"
    
    echo "  sd help --> Display this message"
    echo "  sd edit --> Open to edit $PORTFOLIO_DIRS"
    
    echo "  sd KEYWORD1     -->sd to search in sdROOT for a directory that is called KEYWORD1."
    echo "  sd KEYWORD1 KEYWORD2 -->sd to search in sdROOT using both keywords to find it."
    echo "    "
    echo "=========================================================="
    echo "EXAMPLES"
    echo "   > aliassd 'source ~/bin/go_dir.csh'"
    echo "   > go create home '$HOME' => Adds name 'home' to file '$PORTFOLIO_DIRS'."
    echo "   > go list                => List all the created names. 'home' should show up."
    echo "   > go home                => This will cd to '$HOME' ."
    echo "   > go remove_all          => Deletes all names from file '$PORTFOLIO_DIRS'."
    echo "    "
    echo "=========================================================="
    echo Created by: alvaro.
    return 0
}

function runOptionMode {
    printFunctionName
    optionMode=${1:=optionMode}
    setAliasName ${argv[1]}
    case $optionMode in
        *alias)
            displayAliasPath
        ;;
        *list)
            displayAliasList
        ;;
        *save | *create)
            saveAlias
        ;;
        *update)
            updateAlias
        ;;
        *delete)
            deleteAlias
        ;;
        *exists)
            setAliasExists
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
    esac
    return
}

#==================================================

function verifyMinArgumentsRequired {
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
    createPortfolio
}

function createPortfolio {
    printFunctionName
    if [ ! -f $PORTFOLIO_DIRS ]; then
        mkdir -p "$(dirname $PORTFOLIO_DIRS)"
        touch $PORTFOLIO_DIRS
    fi
}

function isEmptyPortfolio {
    printFunctionName
    if [ -s $PORTFOLIO_DIRS ]; then
        aliasListEmpty=false
    else
        aliasListEmpty=true
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

function displayAliasList {
    printFunctionName
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g'
    exitSourcedScript
}

#==================================================

function setAliasList {
    printFunctionName
    aliasList="$(cat $PORTFOLIO_DIRS | cut -d ":" -f1)"
    return
}


function setAliasName {
    printFunctionName
    aliasName=${1:=${argv[1]}}
}

function setAliasPath {
    printFunctionName
    aliasPath=$(eval realpath $1)
    if [ ! -d $aliasPath ]; then
        aliasPath=$(dirname $aliasPath)
    fi
}

function getAliasPath {
    printFunctionName
    aliasName=$1
    for aliasDBLine in $(cat $PORTFOLIO_DIRS); do
        aliasDBName=$(echo ${aliasDBLine} | cut -d ":" -f1)
        if [[ "$aliasDBName" =~ "$aliasName" ]]; then
            aliasPath=$(echo $aliasDBLine | cut -d ":" -f4-)
            aliasPath=$(eval echo $aliasPath)
            return
        fi
    done
}
function displayAliasPath {
    printFunctionName
    aliasName=${argv[1]}
    setAliasExists $aliasName
    if ${aliasExists}; then
        getAliasPath $aliasName
        echo $aliasPath
    fi
}
function setAliasExists {
    printFunctionName
    aliasName=$1
    isInFile=$(cat $PORTFOLIO_DIRS | grep -c "$aliasName")
    if [ $isInFile -eq 0 ]; then
        aliasExists=false
    else
        aliasExists=true
    fi
}

function getAliasExists {
    printFunctionName
    setAliasName
    setAliasExists $aliasName
    echo $aliasExists
}



function saveAlias {
    printFunctionName
    if [ ${#argv[@]} -ne 3 ]; then
        echo "usage: go save <aliasName> <aliasPath>"
        return
    fi
    setAliasName    ${argv[1]}
    setAliasExists  $aliasName
    if ${aliasExists}; then
        echo "The current alias $aliasName exists."
        echo -e "If you want to update use: \n \t go update <aliasName> <newDir>"
        exitSourcedScript
    else
        setAliasPath $argv[2]
        echo Creating alias "$aliasName:::${aliasPath}"
        echo -e "$aliasName:::${aliasPath}" >> ${PORTFOLIO_DIRS}
    fi
}

function updateAlias {
    printFunctionName
    if [ ${#argv[@]} -ne 3 ]; then
        echo "usage: go update <aliasName> <aliasPath>"
        return
    fi
    setAliasName    ${argv[1]}
    setAliasExists  $aliasName
    
    if ${aliasExists}; then
        deleteAlias
        saveAlias
    else
        echo "Alias not found"
    fi
}

function deleteAlias {
    printFunctionName
    if [ ${#argv[@]} -ne 2 ]; then
        echo "usage: go delete <aliasName>"
        return
    fi
    setAliasName    ${argv[1]}
    setAliasExists  $aliasName
    if ${aliasExists}; then
        sed -i "/${aliasName}/c\ " ${PORTFOLIO_DIRS}
        sed -i "/^${aliasName}/d" ${PORTFOLIO_DIRS}
    fi
    return
}
#==================================================

function removeAll {
    printFunctionName
    rm -f ${PORTFOLIO_DIRS}
    touch ${PORTFOLIO_DIRS}
    exitSourcedScript
}

#==================================================
function setGoFindRoot {
    printFunctionName
    setAliasExists  $aliasName
    if ${aliasExists}; then
        getAliasPath $aliasName
        goFindRoot=$aliasPath
        KWGREP=${argv:3}
    else
        goFindRoot=$GOROOT
        KWGREP=${argv[@]}
    fi
}

function create_find_grep_cmd {
    printFunctionName
    goFindCmd="find $goFindRoot -type d"
    for keyword in $KWGREP; do
        goFindCmd+=' | grep '
        goFindCmd+=\"$keyword\"
    done
    goFindCmd+=' | head -1'
}

function goDirectory {
    printFunctionName
    goPath=$(eval $goFindCmd)
    cd $goPath >& /dev/null || cd $goFindRoot
    pwd
}


function addComplete {
    printFunctionName
    complete -W "$aliasList $optionList" go
    sed -i "/^ /d" ${PORTFOLIO_DIRS}
    
}

function setOptionList {
    printFunctionName
    optionList="(list save create exists update delete remove_all edit help)"
}

function setOptionExists {
    printFunctionName
    optionName=$1
    optionExists=false
    dprint $optionList
    dprint $optionName
    if [[ "$optionList" =~ "$optionName" ]]; then
        optionExists=true
    fi
    return
}

function _begin {
    setSourcedScript
    setHelp
    setPortfolioName
    setGOROOT
    setAliasList
    setOptionList
    verifyMinArgumentsRequired
}

function _main {
    setOptionExists ${argv[0]}
    if $optionExists; then
        runOptionMode $optionName
    else
        setAliasName ${argv[0]}
        setAliasExists $aliasName
        setGoFindRoot
        create_find_grep_cmd
        goDirectory
    fi
}

function _end {
    addComplete
    exitSourcedScript
}

function sd {
    argv=($@)
    _begin
    _main
    _end
}
