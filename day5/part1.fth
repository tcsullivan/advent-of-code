\ Advent of Code 2023, Day 5 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part1.fth

\ Each seed takes two cells: one number and one "transformed" flag.
create seeds 50 2* cells allot
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
  drop over ! 2 cells + repeat
  2drop seedsend ! ;

: clear-flags
  seedsend @ seeds do 0 i cell+ ! 2 cells +loop ;

: in-range? ( src-s src-l n -- b )
  rot -
  tuck > swap 0 >= and ;

: transform ( dst-s src-s n -- n )
  swap - + ;

: apply-transform ( dst-s src-s src-l -- )
  seedsend @ seeds do
  i cell+ @ 0= if
  2dup i @ in-range? if
  -rot 2dup i @ transform i ! rot
  true i cell+ ! then
  then 2 cells +loop 2drop drop ;

: apply-transforms ( ... -- )
  clear-flags
  depth 3 / 0 do
  apply-transform
  loop ;

: show-seeds
  seedsend @ seeds do i ? 2 cells +loop ;

: lowest-seeds
  seeds @
  seedsend @ seeds 2 cells +
  do i @ min 2 cells +loop ;

: map: ;
: seed-to-soil ;
: soil-to-fertilizer apply-transforms ;
: fertilizer-to-water apply-transforms ;
: water-to-light apply-transforms ;
: light-to-temperature apply-transforms ;
: temperature-to-humidity apply-transforms ;
: humidity-to-location apply-transforms ;

include input

apply-transforms
lowest-seeds . cr bye

