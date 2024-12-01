\ Advent of Code 2023, Day 5 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part2.fth
\
\ Input file changes:
\ - Prefix "map:" lines with "create "
\ - Add a line containing "end" after each map definition

include common.fth

variable minnn
99999999999 minnn !

: process-one ( a b -- )
  99999999999 -rot
  over + swap do
  i seed-to-location min
  loop
  minnn @ min minnn ! ;

require cilk.fs

: process-seeds
  cilk-init
  seedsend @ seeds do
  i @ i cell+ @
  ['] process-one spawn2
  2 cells +loop
  cilk-sync
  minnn @ ;

process-seeds . cr
bye

