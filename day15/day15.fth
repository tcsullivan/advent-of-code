include ../common.fth

defer dir
0 value width
0 value height
0 value map
0 value steps
create stepsu 0 ,

: save-line ( c-addr u -- )
  ?dup if
  over c@ [char] # = if
  dup to width allot drop
  height 1+ to height 
  else dup allot stepsu +! drop then
  else drop then ;
: map@   ( j i -- n ) swap width * + map + c@ ;
: map!   ( n j i -- ) swap width * + map + c! ;
: empty? ( j i -- b ) map@ [char] . = ;
: empty! ( j i -- )   [char] . -rot map! ;
: dump-map ( -- )     height 0 do width 0 do j i map@ emit loop cr loop ;
: find-robot ( -- )   height 0 do width 0 do j i map@ [char] @ =
                      if j i unloop unloop exit then loop loop ;

: east ( j i -- j i ) 1+ ;
: west ( j i -- j i ) 1- ;
: north ( j i -- j i ) swap 1- swap ;
: south ( j i -- j i ) swap 1+ swap ;
: travel ( j i -- b )
  2dup map@ [char] # = if 2drop false exit then
  2dup dir empty? if
  2dup map@ >r 2dup empty! dir r> -rot map! true
  else 2dup dir recurse if recurse else 2drop false then then ;
: run-step ( j i n -- b )
  case
  [char] ^ of ['] north endof
  [char] v of ['] south endof
  [char] < of ['] west endof
  [char] > of ['] east endof
  endcase is dir travel ;
: run-robot ( n -- )
  find-robot rot run-step drop ; \ 0= if ." Ow!" cr then ;
: run-robot-all ( -- )
  steps stepsu @ over + swap do i c@ run-robot loop ;
: gps-sum ( -- n )
  0 height 0 do width 0 do j i map@ [char] O =
  if j 100 * i + + then loop loop ;

cr
here to map
open-input ' save-line each-line
map width height * + to steps
run-robot-all
." Part 1: " gps-sum . cr
bye
