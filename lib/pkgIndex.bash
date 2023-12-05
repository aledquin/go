#!/bin/bash

_sargv=($@)


function Package.pkgIndexcall {
    dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    local root=$(realpath $dir/../)
    local RealBin="${root}/bin"
}

function Package.import {
    printFunctionName
    _import $@ || ( eprint $1 was not imported  || echo Messaging package not found ) && return 1
}

function Package._import {
    _fargs=($@)
    local dir
    pkgIndexcall
    local name_package="${_fargs[0]}"
    source_file_path="${dir}/${name_package}.bash"
    [ -r $source_file_path ] && source $source_file_path || return 1
    [ "${_fargs[1]}" =~ "export" ] && \

}

function Package._migrate {
    _fargs=($@)
    
}


function Package.copy_function {
  test -n "$(declare -f "$1")" || return 
  eval "${_/$1/$2}"
}

function Package.rename {
  copy_function "$@" || return
  unset -f "$1"
}








import Messaging
import Misc 

