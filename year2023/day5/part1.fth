\ Advent of Code 2023, Day 5 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part1.fth
\
\ Input file changes:
\ - Prefix "map:" lines with "create "
\ - Add a line containing "end" after each map definition

include common.fth

: process-seeds
  99999999999
  seedsend @ seeds @ do
  i @ seed-to-location min
  1 cells +loop ;

process-seeds . cr
bye

