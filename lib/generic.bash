


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
    dprint "$num_var = ${!num_var}"
    return 0
}


function defined {
    local variable_name=$1
    [[ -v $@ ]] && return 0 || return 1
}