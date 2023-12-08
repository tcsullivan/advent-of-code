\ Advent of Code 2023, Day 8 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Wrap path with ": path s" " and "" ;" 
\ - Prefix map with line containing "create network"
\ - Modify each line to be in this format: "JKT , KFV , CFQ ,"

36 base !

include input

: start? ( n -- b )
  10 mod A = ;
: end? ( n -- b )
  10 mod Z = ;

: gcd ( n n -- n )
  dup 0= if drop exit then
  dup rot swap mod recurse ;

: lcm ( n n -- n )
  2dup gcd -rot / * ;

: find-node ( n -- c-addr )
  network >r begin
  dup r@ @ <> while r> 3 cells + >r repeat
  drop r> ;

: left@ ( c-addr -- n )
  cell+ @ ;

: right@ ( c-addr -- n )
  cell+ cell+ @ ;

: path-step ( n -- c n )
  path >r over + c@ swap
  1+ dup r> = if drop 0 then ;

: all-start ( -- n... )
  network begin
  dup @ 0<> while
  dup @ start? if
  dup @ swap then
  3 cells + repeat drop ;

: find-end ( n -- n )
  0 pad ! 0 >r begin
  dup end? 0= while
  find-node
  r> path-step >r
  [char] L = if left@ else right@ then
  1 pad +!
  repeat r> 2drop pad @ ;

: find-all ( n... -- n... )
  depth 0 do find-end depth 1- roll loop ;

: do-lcm ( n... -- n )
  1
  depth 1- 0 do
  2dup * -rot gcd / loop ;

AAA decimal
." Part 1: " find-end . cr
." Part 2: " all-start find-all do-lcm . cr
bye

