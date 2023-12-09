\ Advent of Code 2023, Day 9 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Replace all spaces and end-of-lines with " , "
\ - Prepend all lines with "here "

: to-range ( c-addr u -- end start )
  cells over + swap ;

: reverse ( c-addr u -- c-addr u )
  2dup 2>r
  2dup to-range do i @ 1 cells +loop
  2r>  to-range do i ! 1 cells +loop ;

: reduce ( c-addr u -- c-addr u-1 )
  1- 2dup to-range do i cell+ @ i @ - i ! 1 cells +loop ;

: get-last ( c-addr u -- n )
  1- cells + @ ;

: all-zero? ( c-addr u -- b )
  to-range true -rot do i @ 0= and 1 cells +loop ;

defer reduce-and-acc :noname ( c-addr u -- n )
  0 -rot begin 2dup get-last
  3 roll + -rot 
  reduce 2dup all-zero? until 2drop ;
is reduce-and-acc

: sum-extrapolation ( ... -- n )
  0 depth 2 - 0 do
  2 pick 2>r over - 1 cells /
  reduce-and-acc 2r> -rot + loop nip ;

include input here
." Part 1: " sum-extrapolation . cr

:noname reverse [ ' reduce-and-acc defer@ compile, ] ; is reduce-and-acc
include input here
." Part 2: " sum-extrapolation . cr
bye

