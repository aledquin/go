#!/bin/bash

_sargv=($@)

function Package.printFunctionName {
    Setup.set_debug $@
    Messaging.dprint "${FUNCNAME[@]:1:DEBUG}"
}

function Package.pkgIndexcall {
    dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    local root=$(realpath $dir/../)
    local RealBin="${root}/bin"
}

function Package.import {
    local pkg_name
    [ $1 == "-force" ] && pkg_name=$2 || pkg_name=$1
    lsearch $pkg_name $BASH_PKGS && echo "$pkg_name exists. Use: import -force $pkg_name" && return
    Package._import $pkg_name || (echo "Error: $pkg_name was not imported") && return 1
}

function Package._import {
    _fargs=($@)
    local dir
    Package.pkgIndexcall
    name_package="${_fargs[0]}"
    [[ $DEBUG -gt 0 ]] && echo "Importing $name_package"
    source_file_path="${dir}/${name_package}.bash"
    [ -r $source_file_path ] && source $source_file_path || return 1
}

function Package.copy_function {
    test -n "$(declare -f "$1")" || return
    eval "${_/$1/$2}"
}

function Package.get_function {
    for function_name in $@; do
        function_RealName=$(declare -F | grep ${function_name} | cut -d ' ' -f3)
        Package.copy_function ${function_RealName} ${function_name}
    done
}

function Package.provide {
    local pkg_name=$1
    [ -v BASH_PKGS ] || BASH_PKGS=()
    lsearch $pkg_name $BASH_PKGS && return || ([[ $DEBUG -gt 0 ]] && echo "$pkg_name is getting added")
    BASH_PKGS=($BASH_PKGS $pkg_name) || echo "Error! $pkg_name"
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

Package.provide Package

DEBUG=1

# Package.import Setup

# Package.import Messaging
# Package.get_function eprint printFunctionName

# Package.import Misc
