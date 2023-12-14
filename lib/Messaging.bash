Package.provide Messaging || echo "Package tool not supported"

_Messaging_logger_temp_file=$(mktemp)

function Messaging.eprint {
    local _fargs=($@)
    local _MESSAGE_="${_fargs[@]}"
    _MESSAGE_="\e[0;31mError:\e[0m $_MESSAGE_"
    echo -e "$_MESSAGE_"
    return
}

function Messaging.dprint {
    local _fargs=($@)
    local _MESSAGE_="\e[0;32DEBUG:\e[0m ${_fargs[@]}"
    DEBUG=${DEBUG:=0}
    [[ $DEBUG -ne "0" ]] && echo "${_MESSAGE_}"
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
    Setup.set_debug ${_fargs[0]}
    echo "${FUNCNAME[@]:1:DEBUG}"
}

# creates two new variables to colorize the message
function get_ansi_color {
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

#eprint error message -> Messaging error error message -> (in red)Error: (resetcolor)error message

function Messaging.print {
    local _fargs=($@)
    local severity=$_fargs
    local _Message=${_fargs[@]:1}

    local color_reset
    local color_ansi

    [[ "$severity" =~ "err" ]] && get_ansi_color red && _prefix='-E-'
    [[ "$severity" =~ "warn" ]] && get_ansi_color yellow && _prefix='-W-'
    [[ "$severity" =~ "info" ]] && get_ansi_color white && _prefix='-I-'
    [[ "$severity" =~ "deb" ]] && get_ansi_color magenta && _prefix='-D-'
    [[ "$severity" =~ "sys" ]] && get_ansi_color cyan && _prefix='-S-'

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

function write_file {
    local _fargs=($@)
    local file_name=${_fargs[0]}
    local content=${_fargs[@]:1}
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