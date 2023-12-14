#!/bin/tcsh -fx
# Created by: alvaro. 2023-10-17 \
set function_VERSION = "1.1.0"
alias append 'set \!:1 = ($\!:1 \!:2-$)'
alias breakpoint 'set fake_variable = $< ; unset fake_variable'

alias _set 'eval (set \!:1) || '



# Proposal
# function name {
#    return 0/1/true/false
# } 
#
# 

alias function 'while 1 ; (eval \!)  ; break ; end'
