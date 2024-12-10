include ../common.fth

0 value width
1 value height
0 value topmap
false value keep-dups

: map-do   postpone height postpone false postpone do
           postpone width  postpone false postpone do
           postpone j postpone i ; immediate
: map-loop postpone loop postpone loop ; immediate

: read-first ( fd -- c-addr ) input-line if dup to width allot else abort then ;
: save-line  ( c-addr u -- )  allot drop height 1+ to height ;
: map@       ( j i -- ch )    swap width * + topmap + c@ ;
: dump-map   ( -- )           map-do map@ emit loop cr loop ;

open-input dup read-first to topmap
' save-line each-line
create scores width height * cells allot

: new-score   here -rot , , -1 , ;
: score       cells swap cells width * + scores + ;
: score!      score ! ;
: score@      score @ ;
: at?         -rot map@ = ;
: score,      ( d s -- ) \ Add score at 's' to 'd'
              keep-dups if nip else
              here rot ?do dup 2@ i 2@ 2= if unloop drop exit then loop
              then dup @ , cell+ @ , ;
: scores,     ( d sy sx -- ) \ Add scores from 's' to 'd'
              score@ begin dup @ 0>= while 2dup score, 2 cells + repeat 2drop ;
: ?scores,    ( d ch sy sx -- ) \ Do 'scores,' if 's' matches 'ch'
              rot >r 2dup r> at? if scores, else 2drop drop then ;
: calc-score  score@ dup begin dup @ 0>= while 2 cells + repeat swap - 2 cells / ;
: dump-scores map-do calc-score . loop cr loop ;
: init-scores map-do [char] 9 at? if j i new-score else 0 then j i score! map-loop ;
: 0-score     0 map-do [char] 0 at? if j i calc-score + then map-loop ;

: score-n ( ch -- ) \ Find 'ch' in map, collect neighbors scores/lists for each match
  map-do 2 pick at? if
  here over 1+ over j i score!
  i if 2dup j i 1- ?scores, then
  j if 2dup j 1- i ?scores, then
  i 1+ width  <> if 2dup j i 1+ ?scores, then
  j 1+ height <> if 2dup j 1+ i ?scores, then
  -1 , 2drop then map-loop drop ;
: score-all [char] 0 [char] 8 do i score-n -1 +loop ;

." Part 1: " init-scores score-all 0-score . cr
true to keep-dups
." Part 2: " init-scores score-all 0-score . cr
bye

