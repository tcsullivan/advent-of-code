include ../common.fth

0 value width
1 value height
0 value wordmap
create loops 6000 allot
create loopsend loops ,
2variable start

: add-loop ( y x -- )
  loopsend @ loops ?do
  i 1+ c@ i c@ 2over 2= if unloop 2drop exit then
  2 +loop
  loopsend @ c! loopsend @ 1+ c! 2 loopsend +! ;

: read-first   ( fd -- c-addr )     input-line if dup to width allot
                                    else abort then ;
: save-line    ( c-addr u -- )      allot drop height 1+ to height ;
: to-map       ( j i -- c-addr )    swap width * + wordmap + ;
: find-start                        height 0 do width 0 do
                                    j i to-map c@ [char] ^ = if
                                    j i unloop unloop exit then
                                    loop loop ;
: mark-pos                          [char] X -rot to-map c! ;
: in-map?                           2dup width < swap height <
                                    and -rot 0 >= swap 0 >= and and ;
: advance                           case
                                    north of swap 1- swap endof
                                     east of 1+ endof
                                    south of swap 1+ swap endof
                                     west of 1- endof
                                    endcase ;
: turn                              1+ 4 mod ;

: safe-advance
  >r 2dup r> advance 2dup to-map c@ [char] # <>
  if 2nip else 2drop then ;

: walk
  north >r begin 2dup in-map? while
  2dup r@ safe-advance 2dup mark-pos
  2tuck 2= if r> turn >r then
  repeat 2drop r> drop ;

: count-x
  0 height 0 do width 0 do j i to-map c@ [char] X = if 1+ then loop loop ;

10000 constant walk2max
: walk2
  0 pad !
  north >r begin 2dup in-map? pad @ walk2max < and while
  2dup r@ safe-advance 2tuck 2= if r> turn >r then
  1 pad +!
  repeat 2drop r> drop pad @ walk2max = ;

: count-loops
  0 height 0 do width 0 do
  j i to-map c@ [char] X = if
    [char] # j i to-map c!
    start 2@ walk2 if 1+ then
    [char] X j i to-map c!
  then loop loop 2 - ; \ -2 for first and last X's

open-input dup read-first to wordmap
' save-line each-line
." Dimensions: " width . ." x " height . cr
find-start 2dup start 2!
walk count-x . cr
count-loops . cr
bye

