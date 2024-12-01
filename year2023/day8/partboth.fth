\ Advent of Code 2023, Day 8 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Wrap path with ": path s" " and "" ;" 
\ - Add a line containing "create network" before the network is defined
\ - Modify each network line to be in this format: "node: JKT KFV CFQ"

36 base !

: get-number ( -- n )           0 s>d bl parse >number 2drop d>s ;
: node:                         3 0 do get-number , loop ;

include input                   \ path ( -- c-addr u ), network ( -- c-addr )
here constant network-end
3 cells constant node

: start? ( n -- b )             10 mod A = ;
: end? ( n -- b )               10 mod Z = ;

: gcd ( n n -- n )              dup if tuck mod recurse else drop then ;
: lcm ( n... u -- n )           1 swap 0 do 2dup * -rot gcd / loop ;

: left@ ( c-addr -- n )         cell+ @ ;
: right@ ( c-addr -- n )        cell+ cell+ @ ;
: find-node ( AAA -- c-addr )   network begin 2dup @ <> while node + repeat nip ;

: path-step ( n -- c n )        path >r over + c@ swap 1+ r> mod ;

: find-one ( AAA -- n )
  0 0 >r begin
  swap find-node r> path-step >r
  [char] L = if left@ else right@ then
  swap 1+ over end? until r> drop nip ;

: find-all ( -- n... )
  network-end network do
  i @ start? if i @ find-one then node +loop ;

." Part 1: " AAA find-one decimal . cr
." Part 2: " find-all depth lcm . cr
bye

