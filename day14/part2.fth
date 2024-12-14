include ../common.fth

101 constant width
103 constant height

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
  1 advance get-number 2drop
  robotend @ tuck ! cell+ tuck ! cell+ tuck ! cell+ tuck ! cell+ robotend ! ;

: move-robots
  robotend @ robots do
  i       @ i 2 cells + @ + height mod i 2 cells + ! \ y
  i cell+ @ i 3 cells + @ + width  mod i 3 cells + ! \ x
  4 cells +loop ;

: draw-robots
  palette width height * bl fill
  robotend @ robots do
  [char] # i 2 cells + @ width * i 3 cells + @ + palette + c!
  4 cells +loop ;
: find-tree
  100000 0 do
  i . cr
  move-robots draw-robots
  height 0 do width 0 do j width * i + palette + c@ emit loop cr loop
  loop ;

open-input ' add-robot each-line
find-tree cr
bye
