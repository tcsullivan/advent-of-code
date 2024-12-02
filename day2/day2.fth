include ../common.fth

0 value fd
defer check
create level-buf 100 cells allot

: read-level        level-buf 100 cells fd read-line throw level-buf -rot ;
: parse-level       evaluate level-buf depth 1- 2dup 2>r cell-do i ! cell-loop 2r> ;
: safe-asc?         2dup < -rot - abs dup 0 > swap 4 < and and ;
: safe-des?         2dup > -rot - abs dup 0 > swap 4 < and and ;
: all-of            true 2swap 1- cell-do over i @ i cell+ @ rot execute and cell-loop nip ;
: all-of-err        2 pick 2 pick cell-do
                    here 2over cell-do
                    i j <> if i @ over ! cell+ then cell-loop
                    here tuck - cell /
                    2 pick all-of
                    if unloop 2drop drop true exit then
                    cell-loop 2drop drop false ;
: safety-check-1    2dup ['] safe-asc? all-of >r
                         ['] safe-des? all-of r> or ;
: safety-check-2    2dup ['] safe-asc? all-of >r
                    2dup ['] safe-des? all-of r> or >r
                    2dup ['] safe-asc? all-of-err r> or >r
                         ['] safe-des? all-of-err r> or ;
: read-all-levels   0 >r begin read-level while
                    parse-level check
                    if r> 1+ >r then repeat 2drop r> ;

s" input" r/o open-file throw to fd
' safety-check-1 ' check defer!
read-all-levels ." Part 1: " . cr

s" input" r/o open-file throw to fd
' safety-check-2 ' check defer!
read-all-levels ." Part 2: " . cr

bye

