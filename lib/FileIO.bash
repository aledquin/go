Package.provide FileIO || echo "Package tool not supported"

function FileIO.write_file {
    local _fargs=($@)
    local file_name=${_fargs[0]}
    local content=${_fargs[@]:1}
    [[ -f $file_name ]] || touch $file_name
    echo -e "$content" >> $file_name
}

function FileIO.read_file {
    local _fargs=($@)
    local file_name=${_fargs[0]}
    [[ -f $file_name ]] || error "File $file_name does not exist."
    [[ -r $file_name ]] || error "File $file_name is not readable."
}
