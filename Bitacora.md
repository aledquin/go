# Changes

Date       | Summary                      | Details
---------- | ---------------------------- | --------------------------------
2023-10-17 | Creation of files            | First draft
2023-10-XX | First Release 1.0            | first release
2023-10-XX | New features on csh          | Accepting more arguments to find. New functions.
2023-11-14 | Adding features to bash      | alias, and more arguments for find/grep
2023-11-15 | New structure for bash script| Reduced content per function. Many new functions.
2023-11-17 | Test format                  | new bash function _test and dprint
2023-11-18 | Tests bash                   | new 10 unit tests passing 
---------- | ---------------------------- | --------------------------------
2023/12/05 | New lib package in bash      | lib directory was created containing many new functions.


# Action Items
- [ ] Create tests for new functions in library
- [ ] Research how to create a function in tcsh...
- [ ] create a process_cmdline_opts for bash
- [ ] create a process_cmdline_opts for csh



 `for i in c,3 e,5; do IFS=","; set -- $i; echo $1 and $2; done`


