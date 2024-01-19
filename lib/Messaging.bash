Package.provide Messaging || echo "Package tool not supported"

_Messaging_logger_temp_file=$(mktemp)

function Messaging.eprint {
    local _fargs=($@)
    local _MESSAGE_="${_fargs[@]}"
    _MESSAGE_="\e[0;31mError:\e[0m $_MESSAGE_"
    echo -e "$_MESSAGE_"
    return
}


function Messaging.vprint {
    local _fargs=($@)
    local _MESSAGE_="${_fargs[@]}"
    VERBOSITY=${VERBOSITY:=0}
    [[ $VERBOSITY -ne "0" ]] && echo "${_MESSAGE_}"
}

function Messaging.printFunctionName {
    local _fargs=($@)
    debug.set ${_fargs[0]}
    echo "${FUNCNAME[@]:1:DEBUG}"
}

#eprint error message -> Messaging error error message -> (in red)Error: (resetcolor)error message

function Messaging.print {
    local _fargs=($@)
    local severity=$_fargs
    local _Message=${_fargs[@]:1}

    local color_reset
    local color_ansi

    [[ "$severity" =~ "err" ]] && ansi_color red && _prefix='-E-'
    [[ "$severity" =~ "warn" ]] && ansi_color yellow && _prefix='-W-'
    [[ "$severity" =~ "info" ]] && ansi_color white && _prefix='-I-'
    [[ "$severity" =~ "deb" ]] && ansi_color magenta && _prefix='-D-'
    [[ "$severity" =~ "sys" ]] && ansi_color cyan && _prefix='-S-'

    _Message="$_prefix $_Message"
    echo -e "$color_ansi $_Message $color_reset"
    Messaging.logger "$_Message"
    return

}

function Messaging.logger {
    local _fargs=($@)
    local file_name=${_Messaging_logger_temp_file:="/tmp/output.log"}
    local content=${_fargs[@]}
    [[ -f $file_name ]] || touch $file_name
    echo -e "$content" >> $file_name
}



# function Messaging.header {
#     local 
# }

# function Messaging.footer {
#     local 
# }

# function Messaging.verifyparameters {
#     AUTHOR=${}
# }