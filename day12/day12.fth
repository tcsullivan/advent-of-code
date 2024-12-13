include ../common.fth

0 value width
1 value height
0 value map

: map-do   postpone height postpone false postpone do
           postpone width  postpone false postpone do
           postpone j postpone i ; immediate
: map-loop postpone loop postpone loop ; immediate

: read-first ( fd -- c-addr )  input-line if dup to width allot else abort then ;
: save-line  ( c-addr u -- )   allot drop height 1+ to height ;
: to-map     ( j i -- c-addr ) swap width * + map + ;
: map@       ( j i -- ch )     to-map c@ ;
: map!       ( ch j i -- )     to-map c! ;
: dump-map   ( -- )            map-do map@ emit loop cr loop ;

0 value id
variable peri
variable area

: peri+ 1 peri +! ;
: calc-stats-impl ( j i -- )
  2dup map@ id <> if map@ [char] . <> if peri+ then exit then
  1 area +! 2dup [char] . -rot map!
  dup              if 2dup 1-      recurse else peri+ then
  dup  width 1-  < if 2dup 1+      recurse else peri+ then
  over             if over 1- over recurse else peri+ then
  over height 1- < if over 1+ over recurse else peri+ then
  2drop ;

: calc-stats ( j i -- peri area )
  0 peri ! 0 area ! 2dup map@
  dup [char] . = over [char] @ = or if drop 2drop else
  to id calc-stats-impl then
  area @ peri @ ;

: cleanup ( -- )
  map-do map@ [char] . = if [char] @ j i map! then map-loop ;

: calc-stats-all ( -- n )
  0 map-do calc-stats * + cleanup map-loop ;

open-input dup read-first to map
' save-line each-line

calc-stats-all . cr
bye
