\ Advent of Code 2023, Day 15 Both parts
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend input with "hash-line "

create hashmap 256 cells allot
hashmap 256 cells 0 fill

: cstrcmp ( c-str c-str -- b )
  dup c@ 1+ 1 do 2dup i + c@ swap i + c@
  <> if 2drop unloop false exit then
  loop 2drop true ;

: box ( u -- a )                cells hashmap + ;
: empty? ( a -- b )             @ 0= ;
: label ( a -- cstr )           cell+ 1+ ;
: focal ( a -- cstr )           cell+ c@ ;
: focal! ( n a -- )             cell+ c! ;
: match? ( a a -- b )           label swap label cstrcmp ;
: -? ( c-addr u -- b )          + 1- c@ [char] - = ;
: =? ( c-addr u -- b )          + 2 - c@ [char] = = ;
: parse-focal ( c-addr u -- n ) + 1- c@ ;
: hash ( c-addr u -- n )        0 -rot over + swap do i c@ + 17 * 256 mod loop ;
: insert ( u addr -- )          swap box
                                dup empty? if ! exit then
                                begin @ \ addr ptr
                                2dup match? if swap focal swap focal! exit then
                                dup empty? until ! ;
: remove ( u addr -- )          swap box
                                dup empty? if 2drop exit then
                                begin dup pad ! @ \ addr ptr
                                2dup match? if @ pad @ ! drop exit then
                                dup empty? until 2drop ;
: new-entry ( c-addr u n -- a ) here >r 0 , [char] 0 - c, dup c, here
                                swap dup allot move r> ;
: box-power ( u -- n )          dup 1+ 0 2>r
                                box 0 swap begin dup @ while @
                                dup focal 2r> 1+ 2dup 2>r * * rot + swap
                                repeat drop 2r> 2drop ;
: total-power ( -- n )          0 256 0 do i box-power + loop ;

: .box ( u -- )
  box begin dup @ while @
  [char] [ emit
  dup label count type space
  dup focal [char] 0 + emit
  [char] ] emit space
  repeat drop ;
: .hashmap 256 0 do i box empty? 0= if i .box cr then loop ;

defer hash-line

:noname
  0 begin [char] , parse dup while
  hash + repeat 2drop ;
is hash-line

cr
include input ." Part 1: " . cr

:noname
  begin [char] , parse dup while
  2dup =? if 2dup parse-focal >r 2 - 2dup hash -rot r> new-entry insert
  else 1- 2dup hash -rot 0 new-entry remove then
  repeat 2drop ;
is hash-line

include input ." Part 2: " total-power . cr
bye

