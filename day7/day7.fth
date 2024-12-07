include ../common.fth

create lineno 1 ,
create sum 0 ,
0 value result
create nums 100 cells allot
nums value numsend

: binary  2 base ! ;
: ternary 3 base ! ;

: advance 1- swap 1+ swap ;
: read-number 0 s>d 2swap >number 2>r d>s 2r> ;
: nums-count numsend nums - cell / ;
: nums-reset nums to numsend ;

: capture-equ
  read-number rot to result advance
  begin dup 0<> while
  advance read-number rot numsend !
  numsend cell+ to numsend repeat 2drop ;

: pow ( x n -- x^n ) dup 0 <= if drop 1 else 1- 0 ?do dup * loop then ;
: concat ( n n -- nn )
  dup 0 >r begin dup 0<> while r> 1+ >r 10 / repeat
  drop swap r> 0 ?do 10 * loop + ;

: figure-equ
  ternary
  base @ nums-count 1- pow 0 do
  nums @ \ result
  nums-count 1 do
  nums i cells + @
  j i 1- 0 ?do base @ / loop
  base @ mod
  case
  0 of + endof
  1 of * endof
  2 of concat endof
  endcase
  loop
  result = if unloop true decimal exit then
  loop false decimal ;

: solve
  lineno ? 1 lineno +!
  capture-equ
  figure-equ
  if result sum +! then
  nums-reset ;

open-input ' solve each-line
sum ? cr
bye

