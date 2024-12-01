include input

depth 2/ constant list-size
create list1 list-size cells allot
create list2 list-size cells allot

: to-lists ( n n addr addr -- )
  3 roll swap ! ! ;

: all-to-lists ( ... u -- )
  list2 list1 rot 0 do
  2dup 2>r to-lists r> cell+ r> cell+ swap
  loop 2drop ;

: insert-sort ( addr u -- )
  1 do                                  \ addr
  dup i cells + @                       \ addr key
  i 1-                                  \ addr key j
  begin
  0 over <=                             \ addr key j 0<=j
  dup if
  2over swap 3 pick cells + @ <         \ addr key j 0<=j key<addr[j]
  and then
  while                                 \ addr key j
  2 pick over cells +                   \ addr key j addr+j
  dup @ swap cell+ !                    \ addr key j
  1- repeat
  1+ cells 2 pick + !                   \ addr
  loop drop ;

: sum-diffs ( -- n )
  0 list-size 0 do
  i cells dup list1 + swap list2 +
  @ swap @ - abs +
  loop ;

: list-count ( n addr u -- n )
  rot 0 swap 2swap
  cells over + swap do
  dup i @ = if swap 1+ swap then
  cell +loop drop ;

: similarity-score ( -- n )
  0 list-size 0 do
  list1 i cells + @ dup
  list2 list-size list-count * +
  loop ;

list-size all-to-lists
list1 list-size insert-sort
list2 list-size insert-sort

cr
sum-diffs ." Part 1: " . cr
similarity-score ." Part 2: " . cr
bye
  
