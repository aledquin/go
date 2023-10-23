# go
'go' is a tool that saves paths you want to go again. It has the option to save paths with their own aliases. 

2 Ways to install 'go':
1) Execute the script in `bin/run.csh`. It does the next step for you.
2) You will need to setup an alias that sources this script. Copy it to your `${HOME}/bin/` and save it in your .alias file:
```
alias go 'source ~/bin/go_dir.csh'
```
==========================================================
```
Usage: go {help|list|create|delete|save|update|edit|remove_all} ?alias? ?path? ?regex?
```
==========================================================

## DESCRIPTION 

   'go' is a tool that saves paths you want to go again. It has the option to save paths with their own aliases. When you save a new alias, it gets added to complete option: 'go <TAB>' and it will show the options.
   It will look directly to you `GOROOT` path if you use a keyword that is not an alias or an option. It uses the first two strings as argument for regex searching for directories. 

==========================================================
## COMMANDS
```
   go list                             --> Display list of alias directories saved
   go create <alias_name> <alias_path> --> save a new alias
   go save   <alias_name> <alias_path> --> save a new alias
   go update <alias_name> <alias_path> --> updaters an old alias
   go remove_all                       --> Delete file that contains alias paths.
   go delete <alias_name>              --> delete an alias
   go help --> Display this message
   go edit --> Open to edit ${HOME}/env/dir_map.${USER}
   go KEYWORD1     --> go to search in GOROOT for a directory that is called KEYWORD1.
   go KEYWORD1 KEYWORD2 --> go to search in GOROOT using both keywords to find it.
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
## FEATURES
1) `go <TAB>` will display the aliases saved in `go` **AND NOW OPTIONS TOO!**
2) When you save a the current directory, use:
   ```
      go save <alias_name> .
   ```
   It will automatically save the evaluated real path.
4) If you want to use paths with env variables. You have to do it using `go edit`
5) Directories are getting saved in: `${HOME}/env/dir_map.${USER}`
   If you want to redefine it, use a env var: 
   ```
    setenv PORTFOLIO_DIRS <new_path>
   ```
6) `GOROOT` is the same.
   ```
    setenv GOROOT <new_path>
   ```
7) `go edit` will open to edit thru your defined `$EDITOR`

8) Create fast aliases using go:
     ```
        go save 1 <path>
        go 1
        go delete 1
     ```
==========================================================
## DANGEROUS
   - Don't use ":" in the alias name.

Created by: aledquin.
