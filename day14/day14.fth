include ../common.fth

101 constant width
103 constant height

create counts 0 , 0 , 0 , 0 ,
create palette width height * allot
create robots 1000 4 * cells allot
create robotend robots ,

: advance ( c-addr u n -- c-addr u )
  tuck - >r + r> ;
: get-number ( c-addr u -- n c-addr u )
  over c@ [char] - = dup >r if 1 advance then
  0 s>d 2swap >number 2swap d>s
  r> if negate then -rot ;
: add-robot ( c-addr u -- )
  2 advance get-number
  1 advance get-number
  3 advance get-number
  1 advance get-number 2drop 2swap
  robotend @ tuck ! cell+ tuck ! cell+ tuck ! cell+ tuck ! cell+ robotend ! ;

: move-robots
  robotend @ robots do
  i 2 cells + 2@ i 2@
  rot + height mod i !
      + width  mod i cell+ !
  4 cells +loop ;

: count-robot ( py px -- )
  swap 2dup width 2/ = swap height 2/ = or if 2drop exit then
  width 2/ < swap height 2/ <
  counts swap if 2 cells + then swap if cell+ then
  1 swap +! ;
: safety-factor ( -- n )
  robotend @ robots do i 2@ count-robot 4 cells +loop
  1 4 0 do counts i cells + @ * loop ;

: pal-xy
  width * + palette + ;
: draw-robots
  palette width height * bl fill
  robotend @ robots do [char] # i 2@ pal-xy c! 4 cells +loop ;
: check-tree
  false height 0 do
  0 false width 0 do i j pal-xy c@ [char] # =
  2dup and if rot 1+ -rot then nip loop drop
  28 > if invert leave then loop ;
: draw-palette
  height 0 do width 0 do i j pal-xy c@ emit loop cr loop ;
: find-tree
  101 1 do move-robots draw-robots
  check-tree if draw-palette i . leave then loop
  safety-factor
  100000 101 do move-robots draw-robots
  check-tree if ( draw-palette ) i leave then loop ;

open-input ' add-robot each-line
find-tree swap 
." Part 1: " . cr
." Part 2: " . cr
bye
