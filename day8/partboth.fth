\ Advent of Code 2023, Day 8 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Wrap path with ": path s" " and "" ;" 
\ - Add a line containing "create network" before the network is defined
\ - Modify each network line to be in this format: "node: JKT KFV CFQ"
\ - Add a line containing "0 ," after the network's definition

36 base !

: get-number ( -- n )           0 s>d bl parse >number 2drop d>s ;
: node:                         3 0 do get-number , loop ;

include input

: start? ( n -- b )             10 mod A = ;
: end? ( n -- b )               10 mod Z = ;

: gcd ( n n -- n )              dup 0= if drop else tuck mod recurse then ;
: lcm ( n n -- n )              2dup gcd -rot / * ;
: all-lcm ( n... -- n )         1 depth 1- 0 do 2dup * -rot gcd / loop ;

: node+ ( c-addr -- c-addr )    3 cells + ;
: find-node ( n -- c-addr )     network begin 2dup @ <> while node+ repeat nip ;

: left@ ( c-addr -- n )         cell+ @ ;
: right@ ( c-addr -- n )        cell+ cell+ @ ;

: path-step ( n -- c n )        path >r over + c@ swap 1+ r> mod ;

: find-end ( n -- n )
  0 swap 0 >r begin
  dup end? 0= while
  find-node r> path-step >r
  [char] L = if left@ else right@ then
  swap 1+ swap repeat r> 2drop ;

: all-start ( -- A... )
  network begin dup @ dup while
  start? if dup @ swap then node+ repeat 2drop ;

: find-all ( A... -- Z... )     depth 0 do find-end depth 1- roll loop ;

AAA decimal
." Part 1: " find-end . cr
." Part 2: " all-start find-all all-lcm . cr
bye

