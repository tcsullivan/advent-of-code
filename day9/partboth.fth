\ Advent of Code 2023, Day 9 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Replace all spaces and end-of-lines with " , "
\ - Prepend all lines with "here "

variable acc

: reverse ( c-addr u -- c-addr u )
  2dup 2>r
  pad over cells +
  swap 0 do
  1 cells - over @ over !
  swap cell+ swap loop 2drop 2r>
  dup 0 do
  pad i cells + @ 2 pick i cells + ! loop ;

: reduce ( c-addr u -- c-addr u-1 )
  2dup 2>r 0 do
  dup cell+ @ over @ - over ! cell+ loop drop 2r> 1- ;

: get-last ( c-addr u -- c-addr u n )
  2dup 1- cells + @ ;

: all-zero? ( c-addr u -- b )
  true pad !
  0 do dup i cells + @ 0= pad @ and pad ! loop
  drop pad @ ;

: reduce-and-acc ( c-addr u -- )
  begin get-last acc +! reduce
  2dup all-zero? until 2drop ;

: part1 ( ... -- )
  0 acc !
  depth 1- 0 do
  over >r over - 1 cells / reduce-and-acc r> loop ;

: part2 ( ... -- )
  0 acc !
  depth 1- 0 do
  over >r over - 1 cells / reverse reduce-and-acc r> loop ;

\ Only one part at a time...
include input here
." Part 1: " part1 acc ? cr
\ ." Part 2: " part2 acc ? cr
bye

