\ Advent of Code 2023, Day 5 common words
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prefix "map:" lines with "create "
\ - Add a line containing "end" after each map definition

variable seeds
variable seedsend

: get-number ( -- n b )
  0 s>d bl parse
  dup 0<> >r
  >number 2drop drop r> ;

: seeds: ( -- )
  here seeds !
  begin get-number while , repeat
  drop here seedsend ! ;

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
  rot - tuck > swap 0 >= and ;

: transform ( dst-s src-s n -- n )
  swap - + ;

: end
  save-transforms
  does> ( n -- n )
  dup @ 0 do
  over >r dup cell+ get-transform
  2dup r> in-range? nip if
  2swap drop transform unloop exit then
  2drop
  3 cells + loop drop ;

: show-seeds
  seedsend @ seeds @ do i ? 1 cells +loop ;

include input

: seed-to-location
  seed-to-soil
  soil-to-fertilizer
  fertilizer-to-water
  water-to-light
  light-to-temperature
  temperature-to-humidity
  humidity-to-location ;

