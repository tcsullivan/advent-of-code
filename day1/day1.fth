include ../common.fth
include input

depth 2/
dup constant list-size
cells dup
create list1 allot
create list2 allot

: all-to-lists ( ... u -- )
  cells 0 do
  list1 i + ! list2 i + !
  cell-loop ;

: sum-diffs ( -- n )
  0 list-size cells 0 do
  i list1 + @ i list2 + @ - abs +
  cell-loop ;

: list-count ( n addr u -- n )
  rot 0 swap 2swap cell-do
  dup i @ = if swap 1+ swap then
  cell-loop drop ;

: list2-count list2 list-size list-count ;
: similarity-score ( -- n )
  0 list1 list-size cell-do
  i @ dup list2-count * +
  cell-loop ;

list-size all-to-lists
list1 list-size insert-sort
list2 list-size insert-sort

cr
sum-diffs        ." Part 1: " . cr
similarity-score ." Part 2: " . cr
bye

