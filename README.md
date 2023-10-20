# go
'go' is a tool that saves paths you want to go again. It has the option to save paths with their own aliases. 
You will need to setup an alias that sources this script. As:

alias go 'source ~/bin/go_dir.csh'

==========================================================

Usage: go {help|list|create|delete|save|update|edit|remove_all} ?alias? ?path? ?regex?

==========================================================

## DESCRIPTION 

   'go' is a tool that saves paths you want to go again. It has the option to save paths with their own aliases. When you save a new alias, it gets added to complete option: 'go <TAB>' and it will show the options.
   It will look directly to you GITROOT path if you use a keyword that is not an alias or an option. It uses the first two strings as argument for regex searching for directories. 
Directories are getting saved in: /u/alvaro/env/dir_map.alvaro
If you want to redefine it, use a env var
: > setenv PORTFOLIO_DIRS <new_path>
    
==========================================================
## COMMANDS
```
   go list --> Display list of alias directories saved
   go create <alias_name> <alias_path> --> save a new alias
   go save   <alias_name> <alias_path> --> save a new alias
   go update <alias_name> <alias_path> --> updaters an old alias
   go remove_all     --> Delete file that contains alias paths.
   go delete <alias_name> --> delete an alias
   go help --> Display this message
   go edit --> Open to edit /u/alvaro/env/dir_map.alvaro
   go KEYWORD1     --> go to search in /u/alvaro/GitLab/ddr-hbm-phy-automation-team for a directory that is called KEYWORD1.
   go KEYWORD1 KEYWORD2 --> go to search in /u/alvaro/GitLab/ddr-hbm-phy-automation-team using both keywords to find it.
```    
==========================================================
## EXAMPLES
```
   > alias go 'source ~/bin/go_dir.csh'
   > go create home '/u/alvaro' => Adds name 'home' to file '/u/alvaro/env/dir_map.alvaro'.
   > go list                => List all the created names. 'home' should show up.
   > go home                => This will cd to '/u/alvaro' .
   > go remove_all          => Deletes all names from file '/u/alvaro/env/dir_map.alvaro'.
```
==========================================================

Created by: alvaro.
