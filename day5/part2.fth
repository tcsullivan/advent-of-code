\ Advent of Code 2023, Day 5 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part2.fth
\
\ Input file changes:
\ - Prefix "map:" lines with "create " 
\ - Add a line containing "end" after each map definition

create seeds 50 cells allot
variable seedsend

: get-number ( -- n b )
  0 s>d bl parse
  dup 0<> >r
  >number 2drop drop r> ;

: seeds: ( -- )
  seeds
  begin
  get-number
  dup while
  drop over ! cell+ repeat
  2drop seedsend ! ;

: map: depth pad ! ;

: save-transforms
  depth pad @ -
  dup 3 / ,
  0 do , loop ;

: get-transform
  >r
  r@ cell+ cell+ @
  r@ cell+ @
  r> @ ;

: in-range? ( src-s src-l n -- b )
  rot -
  tuck > swap 0 >= and ;

: transform ( dst-s src-s n -- n )
  swap - + ;

: end
  save-transforms
  does> ( n -- n )
  dup @ 0 do
  over >r dup cell+ get-transform
  2dup r> in-range? if
  drop 2swap drop transform unloop exit then
  2drop drop
  3 cells +
  loop drop ;

: show-seeds
  seedsend @ seeds do i ? 1 cells +loop ;

include input

: seed-to-location
  seed-to-soil
  soil-to-fertilizer
  fertilizer-to-water
  water-to-light
  light-to-temperature
  temperature-to-humidity
  humidity-to-location ;

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

