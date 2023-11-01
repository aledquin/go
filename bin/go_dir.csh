#!/bin/tcsh -fx
# Created by: alvaro. 2023-10-17 \
set GOCD_VERSION "1.1.0"
alias append 'set \!:1 = ($\!:1 \!:2-$)'
alias breakpoint 'set fake_variable = $< ; unset fake_variable'


set DOUSAGE = 'Usage: go {help|list|create|delete|save|update|alias|exists|edit|remove_all} ?alias? ?KEYWORD1[ KEYWORD2]...?'
set optionList = "list save update delete remove_all edit alias exists help"

DEFAULT:
    if !($?PORTFOLIO_DIRS) then
        set PORTFOLIO_DIRS = ${HOME}/env/dir_map.${USER}
        goto DEFAULT
    else if !( -f $PORTFOLIO_DIRS ) then
        set PORTIR_PATH = `dirname $PORTFOLIO_DIRS`
        if !( -d $PORTIR_PATH ) mkdir -p $PORTIR_PATH
        touch $PORTFOLIO_DIRS
        goto EXIT_THE_SCRIPT
    else if !( $?GOROOT ) then
        set GOROOT = $HOME
        echo "No GOROOT variable found. Setting as $HOME."
        goto DEFAULT
    endif


REQUIREMENTS:
    # echo REQUIREMENTS
    if ( $#argv < 1 ) then
        echo "$DOUSAGE"    
        goto EXIT_THE_SCRIPT
    endif


SETUP:
    # echo SETUP
    set ALIAS_CONTENT = `cat $PORTFOLIO_DIRS`
    set ALIAS_LIST = `cat $PORTFOLIO_DIRS | cut -d ':' -f1 `
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
        case start:
            goto EXIT_THE_SCRIPT
        case exists:
            goto VERIFY_EXISTS
        case alias:
            goto DISPLAY_ALIAS_PATH
        case version:
            goto GET_GO_VERSION
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

    echo "   go alias <alias_name> --> get an alias path"
    echo "   go exists <alias_name> --> return true or false if alias exists"


    echo "   go help --> Display this message"
    echo "   go edit --> Open to edit $PORTFOLIO_DIRS"

    echo "   go KEYWORD1     --> go to search in $GOROOT for a directory that is called KEYWORD1."
    echo "   go KEYWORD1 KEYWORD2 ... --> go to search in $GOROOT using both keywords to find it."
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
    echo 'Mirror: git clone https://github.com/aledquin/go.git'
    
    goto EXIT_THE_SCRIPT


VERIFY_EXISTS:
    set alias_name = $argv[2]
    set ALIAS_EXISTS = `grep $alias_name ${PORTFOLIO_DIRS} | wc -l`
    if ($ALIAS_EXISTS > 0) then 
        echo true 
    else
        echo false
    endif
    unset ALIAS_EXISTS
    goto EXIT_THE_SCRIPT


EDITING:
    if !($?EDITOR) set EDITOR = "vi"
    $EDITOR $PORTFOLIO_DIRS
    goto EXIT_THE_SCRIPT

DISPLAY_ALIAS_PATH:
    set alias_name = $argv[2]
    grep "$alias_name" ${PORTFOLIO_DIRS} | cut -d ":" -f4-
    goto EXIT_THE_SCRIPT


DISPLAY_LIST:
    cat ${PORTFOLIO_DIRS} | sed 's/:::/\t--> /g' 
    goto EXIT_THE_SCRIPT


SAVE_IN_DB:
    if ($#argv != 3) then 
        echo "usage: go create alias_name directory"
    else
        set alias_name = $argv[2]
        set ALIAS_DIR  = `readlink -f $argv[3]`
        if !(-d $ALIAS_DIR) set ALIAS_DIR  = `dirname $ALIAS_DIR`
        set ALIAS_EXISTS = `grep "$alias_name\*" ${PORTFOLIO_DIRS} | wc -l`
        if ($ALIAS_EXISTS > 0) then
            echo $ALIAS_EXISTS
            goto UPDATE
        else 
            echo "${alias_name}:::${ALIAS_DIR}" >> ${PORTFOLIO_DIRS}
        endif
    endif
    goto EXIT_THE_SCRIPT


UPDATE:
    if ($#argv != 3) then 
        echo "usage: go update alias_name directory"
    else
        set alias_name = $argv[2]
        set ALIAS_DIR  = `readlink -f $argv[3]`
        if !(-d $ALIAS_DIR) set ALIAS_DIR  = `dirname $ALIAS_DIR`
        set ALIAS_EXISTS = `grep "$alias_name\*" ${PORTFOLIO_DIRS} | wc -l`
        if ($ALIAS_EXISTS) sed -i "/${alias_name}/c\${alias_name}\:\:\:${ALIAS_DIR}" ${PORTFOLIO_DIRS}
    endif
    goto EXIT_THE_SCRIPT


DELETE:
    set alias_name = "$argv[2]"
    if ($#argv != 2) then 
        echo "usage: go delete alias_name"
    else
        set ALIAS_EXISTS = `grep "$alias_name" ${PORTFOLIO_DIRS} | wc -l`
        if ($ALIAS_EXISTS) sed -i "/${alias_name}/c\ " ${PORTFOLIO_DIRS}
    endif
    goto EXIT_THE_SCRIPT


GO_TO:
    set alias_name = "$argv[1]"
    set GOFIND = $GOROOT
    set KWGREP = ( $argv[*] )


GET_ALIAS_PATH:
    foreach alias_DB ("`cat $PORTFOLIO_DIRS`") 
        if (`echo ${alias_DB} | cut -d ":" -f1` =~ "$alias_name") then
            set ALIAS_DIR = `echo $alias_DB | cut -d ":" -f4-`
            set GOFIND = `eval realpath $ALIAS_DIR`
            set KWGREP = ( $argv[2-] )
            break
        endif
    end


CREATE_COMMAND:
    set go_find_cmd = "find $GOFIND -type d"
    foreach keyword ($KWGREP)
        append go_find_cmd '| grep '
        append go_find_cmd \"$keyword\"
    end
    append go_find_cmd '| head -1'
    # eval echo \"Go find_command: $go_find_cmd\"


EXECUTE_CD:
    set find_result = `eval $go_find_cmd`
    # echo "Found Result: $find_result"
    cd $find_result >& /dev/null || cd $GOFIND
    pwd
    goto EXIT_THE_SCRIPT


CLEAN:
    rm -f ${PORTFOLIO_DIRS}

GET_GO_VERSION:
    echo $GOCD_VERSION

EXIT_THE_SCRIPT:
    sed -i "/^ /d"  ${PORTFOLIO_DIRS}
    set ALIAS_LIST = `cat $PORTFOLIO_DIRS | cut -d ':' -f1 | sed 's/\n/ /g' `
    set completion = "$ALIAS_LIST $optionList" 
    
    complete go 'p/1/`eval echo ${completion}`/' 
    unset DOUSAGE


