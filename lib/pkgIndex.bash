#!/bin/bash
_sargv=($@)
[[ $DEBUG -gt 0 ]]  && set -o errtrace
[[ $VERBOSITY -gt 0 ]]  && set -o verbose

function pkgIndexcall {
    dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    local root=$(realpath $dir/../)
    local RealBin="${root}/bin"
}

function import {
    _import $@ || printFunctionName 2 && return 1
}

function eprint {
    echo -ne "\e[0;31mError:\e[0m "
    echo $@
    return 1
}

function _import {
    _fargs=($@)
    pkgIndexcall
    name_package="${_fargs[0]}"
    source_file_path="${dir}/${name_package}.bash"
    [ -r $source_file_path ] && source $source_file_path && return 1 || return 1
}


import Misc 

