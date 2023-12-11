#!/bin/bash

_sargv=($@)

function printFunctionName
{
    Setup.set_debug $@
    Messaging.dprint "${FUNCNAME[@]:1:DEBUG}"
}

function Package.pkgIndexcall {
    dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    local root=$(realpath $dir/../)
    local RealBin="${root}/bin"
}

function Package.import {
    Package._import $@ || ( eprint $1 was not imported || echo Messaging package not found ) && return 1
}

function Package._import {
    _fargs=($@)
    local dir
    Package.pkgIndexcall
    name_package="${_fargs[0]}"
    echo "Importing $name_package"
    source_file_path="${dir}/${name_package}.bash"
    [ -r $source_file_path ] && source $source_file_path || return 1
    
}

function Package._migrate {
    _fargs=($@)
    for function_imported in ${_fargs[@]} ; do
        Package.copy_function "${name_package}.${function_imported}" "${function_imported}"
        declare -f "${function_imported}"
    done
}



function Package.copy_function {
    test -n "$(declare -f "$1")" || return
    eval "${_/$1/$2}"
}

function Package.rename {
    copy_function "$@" || return
    unset -f "$1"
}

function Package.get_function {
    for function_name in $@; do
        function_RealName=$(declare -F | grep ${function_name} | cut -d ' ' -f3)
        Package.copy_function ${function_RealName} ${function_name}
        eval ${function_name}
    done
}


DEBUG=1

Package.import Setup

Package.import Messaging
Package.get_function eprint printFunctionName

Package.import Misc

