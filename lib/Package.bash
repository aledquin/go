#!/bin/bash

_sargv=($@)

function Package.__init__ {
    Package.printFunctionName
    [[ -v __run ]] && return 0
    local dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    source $dir/generic.bash
    source $dir/debug.bash
    __run=true

}

function Package.exit {
    Package.printFunctionName
     [[ $DEBUG -gt 0 ]] && return 1 ||  exit 1
}

function Package.printFunctionName {
    echo -e "${FUNCNAME[@]:1:1} ${_fargs[@]}"
}

function Package.pkgIndexcall {
    local _fargs=($@)
    Package.printFunctionName

    dir=$(dirname $(realpath ${BASH_SOURCE[0]}))
    local root=$(realpath $dir/../)
    local RealBin="${root}/bin"
}

function Package.require {
    local _fargs=($@)
    Package.printFunctionName
    Package.import -force ${_fargs[0]} && return 0 || (echo "Package ${_fargs[0]} was not found. Please use package import") && Package.exit

}

function Package.import {
    Package.printFunctionName
    local pkg_name
    [ $1 == "-force" ] && pkg_name=$2 || pkg_name=$1
    lsearch $pkg_name $BASH_PKGS && echo "$pkg_name exists. Use: import -force $pkg_name" && return 0
    Package._import $pkg_name && return 0 || (echo "Error: $pkg_name was not imported") && return 1
}

function Package._import {
    local _fargs=($@)
    Package.printFunctionName
    local dir
    Package.pkgIndexcall
    name_package="${_fargs[0]}"
    [[ $DEBUG -gt 0 ]] && echo "Importing $name_package"
    source_file_path="${dir}/${name_package}.bash"
    [[ -r $source_file_path ]] && source $source_file_path || return 1
}

function Package.copy_function {
    local _fargs=($@)
    Package.printFunctionName

    test -n "$(declare -f "$1")" || return 1
    eval "${_/$1/$2}" && return 0
}

function Package.get_function {
    local _fargs=($@)
    Package.printFunctionName
    for function_name in $@; do
        function_RealName=$(declare -F | grep ${function_name} | cut -d ' ' -f3)
        Package.copy_function ${function_RealName} ${function_name}
    done
    return 0
}

function Package.provide {
   local _fargs=($@)
   Package.printFunctionName
    local pkg_name=$1
    [[ -v BASH_PKGS ]] || BASH_PKGS=()
    (lsearch $pkg_name $BASH_PKGS) && return 0 || ([[ $DEBUG -gt 0 ]] && echo "$pkg_name is getting added")
    BASH_PKGS=($BASH_PKGS $pkg_name) || echo "Error! $pkg_name"
}

Package.__init__
Package.provide Package

DEBUG=1

# Package.import Setup

# Package.import Messaging
# Package.get_function eprint printFunctionName

# Package.import Misc
