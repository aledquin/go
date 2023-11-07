#!/usr/bin/tcsh -f

# go 
set ROOTDIR = `dirname $0`
set ENV_DIR = "${HOME}/env"
set instance = `date +"%F-%H-%M"`

cp -f "${ROOTDIR}/go_dir.csh" "${HOME}/bin/go_dir.csh"

if (-f ${ENV_DIR}.${instance}/dir_map.${USER}) then 
    cp -f ${ENV_DIR}.${instance}/dir_map.${USER} ${ENV_DIR}/dir_map.${USER}
endif

if !(-f ${HOME}/.cshrc) touch ${HOME}/.cshrc
if !(`grep "alias go" ${HOME}/.cshrc | wc -l`) then
    echo alias go source ${HOME}/bin/go_dir.csh >> ${HOME}/.cshrc.${USER}
endif

exit