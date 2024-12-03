-1 value mul-start
-1 value mul-end
 1 value enabled
create sum1 0 ,
create sum2 0 ,

: s=            tuck compare 0= ;
: reset-mul     -1 to mul-start -1 to mul-end ;
: mul-len       mul-end mul-start - 1+ ;
: advance       rot over + -rot - ;
: get-number    0 s>d 2swap >number 2>r d>s 2r> ;

: check-mul ( addr -- )
  mul-len 0<                   if drop exit then
  mul-start +
  dup s" mul(" s= 0=           if drop exit then
  mul-len 4 advance get-number
  over c@ [char] , <>          if 2drop drop exit then
  1 advance get-number
  1 <> swap c@ [char] ) <> or  if 2drop exit then
  * dup sum1 +! enabled * sum2 +! ;

: scan-chars ( addr u -- )
  0 do i over +
  dup s" do()"    s= if 1 to enabled then
  dup s" don't()" s= if 0 to enabled then
  c@ case
  [char] m of i to mul-start endof
  [char] ) of i to mul-end dup check-mul endof
  endcase
  loop drop ;

: scan-all-muls ( fd -- )
  >r begin here 4096 r@ read-line throw while
  here swap reset-mul scan-chars
  repeat r> 2drop ;

s" input" r/o open-file throw scan-all-muls
." Part 1: " sum1 ? cr
." Part 2: " sum2 ? cr
bye

