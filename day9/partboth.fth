\ Advent of Code 2023, Day 9 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Append " process" to all lines

: to-range ( c-addr u -- end start )
  cells over + swap ;

: save-stack ( a1 ... au c-addr u -- )
  to-range do i ! 1 cells +loop ;

: reverse ( c-addr u -- )
  2dup to-range do i @ -rot 1 cells +loop save-stack ;

: reduce ( c-addr u -- c-addr u-1 )
  1- 2dup to-range do i cell+ @ i @ - i ! 1 cells +loop ;

: all-zero? ( c-addr u -- b )
  to-range true -rot do i @ 0= and 1 cells +loop ;

: reduce-and-acc ( c-addr u -- n )
  0 -rot begin
  2dup 1- cells + @ 3 roll + -rot
  reduce 2dup all-zero? until 2drop ;

: process ( n xt -- n xt )
  depth 2 - pad swap dup >r save-stack r>
  over pad -rot execute rot + swap ;

0 :noname 2dup reverse reduce-and-acc ;
include input drop ." Part 1: " . cr

0 ' reduce-and-acc
include input drop ." Part 2: " . cr

bye

