

function error {
    _fargs=($@)
    (Messaging.print err ${_fargs[@]}) && return 1
}

function is_integer {
    local _fargs=($@)
    Messaging.printFunctionName
    if ! [[ "$_fargs" =~ ^-?[0-9.]+$ ]]; then
        echo "$_fargs is not an integer"
        return 1
    else
        echo "$_fargs is integer"
        return 0
    fi
}

function lappend {
    local _fargs=$@
    local list_name=${_fargs[@]:0:0}
    declare -a $list_name
    local vals_to_add=${_fargs[@]:1}
    for new_val in $vals_to_add; do
        eval ${list_name}+=$new_val
    done
    return 0
}

function lsearch {
    local _fargs=($@)
    local element_to_look_for=${_fargs[0]}
    local list_to_look_in=${_fargs[1]}
    for element_in_list in $list_to_look_in; do
        if [ $element_to_look_for == $element_in_list ]; then
            return 0
        fi
    done
    return 1
}


function incr {
    local _fargs=($@)
    local num_var=${_fargs[0]}
    local num_val=${!num_var:=0}
    local add_val=${_fargs[1]:=1}

    (is_integer $num_val) && (is_integer $add_val) || return 1

    num_val=$((num_val + add_val))
    eval $num_var=$num_val
    debug.print "$num_var = ${!num_var}"
    return 0
}

function defined {
    local variable_name=$1
    [[ -v $@ ]] && return 0 || return 1
}

# creates two new variables to colorize the message
function ansi_color {
    [[ -v Messaging.nocolor ]] && color_reset='' && color_ansi='' && return
    color_reset='\e[0;0m'
    local color_name=($1)
    case $color_name in
    red)
        color_ansi='\e[0;31m'
        ;;
    green)
        color_ansi='\e[0;32m'
        ;;
    yellow)
        color_ansi='\e[0;33m'
        ;;
    blue)
        color_ansi='\e[0;34m'
        ;;
    magenta)
        color_ansi='\e[0;35m'
        ;;
    cyan)
        color_ansi='\e[0;36m'
        ;;
    white)
        color_ansi='\e[0;37m'
        ;;
    *)
        color_ansi='\e[0;0m'
        ;;
    esac
    return
}

