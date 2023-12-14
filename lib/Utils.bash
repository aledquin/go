Package.provide Utils || echo "Package tool not supported"

function Utils.setSourcedScript {
    printFunctionName
    (return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
}

function Utils.exitIfNotSourced {
    printFunctionName
    [[ "$SOURCED" != "0" ]] || exit
}

function Utils.incr {
    printFunctionName
    local _fargs=($@)
    local num_var=${_fargs[0]}
    local num_val=${!num_var:=0}
    local add_val=${_fargs[1]:=1}

    (Setup.is_integer $num_val) && (Setup.is_integer $add_val) || return 1

    num_val=$((num_val + add_val))
    eval $num_var=$num_val
    dprint "$num_var = ${!num_var}"
    return 0
}

function Utils.defined {
    [ -v $@ ] && return 0 || return 1
}
