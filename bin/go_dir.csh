#!/bin/tcsh -fvx
# Created by: alvaro. 2023-10-17 \

set DOUSAGE = "Usage: go {help|list|create|delete|save|update|edit|remove_all} ?alias? ?path? ?regex?"

REQUIREMENTS:
    # echo REQUIREMENTS
    if ( $#argv < 1 ) then
        echo "$DOUSAGE"    
        goto EXIT_THE_SCRIPT
    else if !($?PORTFOLIO_DIRS) then
        goto DEFAULT
    else if !( -f $PORTFOLIO_DIRS ) then
        if !( -d ${HOME}/env ) mkdir ${HOME}/env
        touch $PORTFOLIO_DIRS
        goto REQUIREMENTS
    else if !( $?GOROOT ) then
        set GOROOT = $HOME
        echo "No GOROOT variable found. Setting as $HOME."
    endif


SETUP:
    # echo SETUP
    set ALIAS_LIST = `cat $PORTFOLIO_DIRS | cut -d ':' -f1 | sed 's/\n/ /g' `
    set optionList = "-list -save -update -delete -remove_all -edit -help"
    switch ($argv[1])
        case list:
            goto DISPLAY_LIST
        case save:
            goto SAVE_IN_DB
        case create:
            goto SAVE_IN_DB
        case update:
            goto UPDATE
        case delete:
            goto DELETE
        case remove_all:
            goto CLEAN
        case help:
            goto HELP
        case edit:
            goto EDITING
        default:
            goto GO_TO
        endsw
    endif



HELP:
    echo "You will need to setup an alias that sources this script. As:"
    echo "   > alias go 'source ~/bin/go_dir.csh'"
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
    
    goto EXIT_THE_SCRIPT



DEFAULT:
    # echo DEFAULT
    set PORTFOLIO_DIRS = ${HOME}/env/dir_map.${USER}
    goto REQUIREMENTS

EDITING:
    if !($?EDITOR) set EDITOR = "vi"
    $EDITOR $PORTFOLIO_DIRS
    goto EXIT_THE_SCRIPT

DISPLAY_LIST:
    # echo DISPLAY_LIST
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g' 
    goto EXIT_THE_SCRIPT

SAVE_IN_DB:
    if ($#argv != 3) then 
        echo "usage: go create alias_name directory"
    else
        set alias_name = $argv[2]
        set alias_dir  = `readlink -f $argv[3]`
        if !(-d $alias_dir) set alias_dir  = `dirname $alias_dir`
        set alias_exis = `grep "$alias_name\*" ${PORTFOLIO_DIRS} | wc -l`
        if ($alias_exis > 0) then
            echo $alias_exis
            goto UPDATE
        else 
            echo "${alias_name}:::${alias_dir}" >> ${PORTFOLIO_DIRS}
        endif
    endif
    goto EXIT_THE_SCRIPT

UPDATE:
    if ($#argv != 3) then 
        echo "usage: go update alias_name directory"
    else
        set alias_name = $argv[2]
        set alias_dir  = `readlink -f $argv[3]`
        if !(-d $alias_dir) then 
            set alias_dir  = `dirname $alias_dir`
        endif
        set alias_exis = `grep "$alias_name\*" ${PORTFOLIO_DIRS} | wc -l`
        sed -i "/${alias_name}/c\${alias_name}\:\:\:${alias_dir}" ${PORTFOLIO_DIRS}
    endif
    goto EXIT_THE_SCRIPT

DELETE:
    if ($#argv != 2) then 
        echo "usage: go delete alias_name"
    else
        set alias_name = "$argv[2]"
        set alias_exis = `grep "$alias_name" ${PORTFOLIO_DIRS} | wc -l`
        echo $alias_exis
        if ($alias_exis) sed -i "/${alias_name}/c\ " ${PORTFOLIO_DIRS}
    endif
    goto EXIT_THE_SCRIPT

GO_TO:
    set alias_name = "$argv[1]"
    if ("$ALIAS_LIST" == "") goto GO_TO_GOROOT_DIR


GO_ALIAS: 
    foreach alias_DB (`cat $PORTFOLIO_DIRS`) 
        if (`echo ${alias_DB} | cut -d ":" -f1` =~ "$alias_name") then
            set ALIAS_DIR = `echo $alias_DB | cut -d ":" -f4-`
            set ALIAS_DIR = `eval echo $ALIAS_DIR`
            cd $ALIAS_DIR
            if ($#argv > 1) then 
                cd `find $ALIAS_DIR -type d | grep ".*$argv[2]" -m 1`
            endif
            goto EXIT_THE_SCRIPT
        endif
    end


GO_TO_GOROOT_DIR:
    if     ($#argv == 2)  then
        cd `find $GOROOT -type d | grep "$argv[1].*$argv[2]" -m 1`
    else if ($#argv == 1) then
        cd `find $GOROOT -type d -name "*$argv[1]*" | head -1`
    endif
    goto EXIT_THE_SCRIPT


CLEAN:
    rm -f ${PORTFOLIO_DIRS}

EXIT_THE_SCRIPT:
    set ALIAS_LIST = `cat $PORTFOLIO_DIRS | cut -d ':' -f1 | sed 's/\n/ /g' `
    set optionList = "list save update delete remove_all edit help"
    set completion = "$ALIAS_LIST $optionList" 
    
    complete go 'p/1/`eval echo ${completion}`/' 
    unset DOUSAGE
