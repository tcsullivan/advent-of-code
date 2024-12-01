include ../common.fth
include input

depth 2/
dup constant list-size
cells dup
create list1 allot
create list2 allot

: all-to-lists ( ... -- )       list-size cells 0 do
                                list1 i + ! list2 i + !
                                cell-loop ;
: list-count ( n addr u -- n )  2>r 0 2r> cell-do
                                over i @ = if 1+ then
                                cell-loop nip ;
: list2-count ( n -- n )        list2 list-size list-count ;

: sum-diffs ( -- n )            0 list-size cells 0 do
                                list1 i + @ list2 i + @
                                - abs + cell-loop ;
: similarity-score ( -- n )     0 list1 list-size cell-do
                                i @ dup list2-count * +
                                cell-loop ;

all-to-lists
list1 list-size insert-sort
list2 list-size insert-sort

cr
sum-diffs        ." Part 1: " . cr
similarity-score ." Part 2: " . cr
bye

