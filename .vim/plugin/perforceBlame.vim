fun! PerforceBlame()
execute ":!python p:/penguin/iak/src/tools/python/p4_introduced.py " .  bufname("%") . " " . line(".")
endfun

