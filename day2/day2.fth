include ../common.fth

0 value fd
defer check
create level-buf 100 cells allot

\ read-level        Reads a line from fd into level-buf
\ parse-level       Evaluates level-buf and stores the resulting stack into level-buf as number cells
\ safe-asc?         Determines if the two numbers have a "safe step" between them
\ safe-des?         ...same but the other direction
\ all-of            Determines if all pairs of cells in the given list satisfy the given xt
\ all-of-x1         ...same except tests every list iteration with one of its cells removed
\ safety-check      Determines if the given list safely ascends or descends
\                   returns two bools, one for exact safety and the other for 1 entry removed
\ read-all-levels   Checks safety of all levels in fd

: read-level      ( -- c-addr u )          level-buf 100 cells fd read-line throw level-buf -rot ;
: parse-level     ( c-addr u -- c-addr u ) evaluate level-buf depth 1- 2dup 2>r cell-do i ! cell-loop 2r> ;
: safe-step?      ( n n -- b )             - abs dup 0 > swap 4 < and ;
: safe-asc?       ( n n -- b )             2dup < -rot safe-step? and ;
: safe-des?       ( n n -- b )             2dup > -rot safe-step? and ;
: all-of          ( c-addr u xt -- b )     true 2swap 1- cell-do over i @ i cell+ @ rot execute and cell-loop nip ;
: all-of-x1       ( c-addr u xt -- b )     2 pick 2 pick cell-do
                                           here 2over cell-do i j <> if i @ over ! cell+ then cell-loop
                                           here tuck - cell /
                                           2 pick all-of
                                           if unloop 2drop drop true exit then
                                           cell-loop 2drop drop false ;
: safety-check    ( c-addr u -- b2 b1 )    2dup ['] safe-asc? all-of >r
                                           2dup ['] safe-des? all-of r> or >r
                                           2dup ['] safe-asc? all-of-x1 >r
                                                ['] safe-des? all-of-x1 r> or r> ;
: read-all-levels ( -- n n )               0 0 2>r begin read-level while
                                           parse-level safety-check
                                           r> swap if 1+ then r> rot if 1+ then >r >r
                                           repeat 2drop 2r> ;

s" input" r/o open-file throw to fd
read-all-levels
." Part 1: " . cr
." Part 2: " . cr
bye

