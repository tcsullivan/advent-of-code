include ../common.fth

0 value result
2 value ebase
create nums 100 cells allot
nums value numsend

create part1 0 ,
create part2 0 ,

: advance 1- swap 1+ swap ;
: read-number 0 s>d 2swap >number 2>r d>s 2r> ;
: nums-count numsend nums - cell / ;
: nums-reset nums to numsend ;

: capture-equ
  read-number rot to result advance
  begin dup 0<> while
  advance read-number rot numsend !
  numsend cell+ to numsend repeat 2drop ;

: pow ( x n -- x^n ) dup 0 <= if drop 1 else 1 swap 0 ?do over * loop then nip ;
: concat ( n n -- nn )
  dup begin dup 0<> while rot 10 * -rot 10 / repeat drop + ;

: figure-equ
  ebase nums-count 1- pow 0 do
  nums @ \ result
  nums-count 1 do
  nums i cells + @
  j i 1- 0 ?do ebase / loop
  ebase mod case
  0 of + endof
  1 of * endof
  2 of concat endof
  endcase loop
  result = if unloop true exit then
  loop false ;

: solve
  capture-equ
  2 to ebase figure-equ if result part1 +! result part2 +! else
  3 to ebase figure-equ if result part2 +! then then
  nums-reset ;

open-input ' solve each-line
." Part 1: " part1 ? cr
." Part 2: " part2 ? cr
bye

