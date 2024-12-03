  -1 value mul-start
true value enabled
create sum1 0 ,
create sum2 0 ,

: s=            tuck compare 0= ;
: advance       rot over + -rot - ;
: get-number    0 s>d 2swap >number 2>r d>s 2r> ;

: check-mul ( addr end -- )
  mul-start tuck - >r + r>
  over s" mul(" s= 0=          if 2drop exit then
  4 advance get-number
  over c@ [char] , <>          if 2drop drop exit then
  1 advance get-number
  1 <> swap c@ [char] ) <> or  if 2drop exit then
  * enabled if dup sum2 +! then sum1 +! ;

: scan-chars ( addr u -- )
  0 do i over +
  enabled over s" do()" s= or
          over s" don't()" s= 0= and to enabled
  c@ case
  [char] m of i to mul-start endof
  [char] ) of dup i 1+ check-mul endof
  endcase loop drop ;

: scan-all-muls ( fd -- )
  >r begin here 4096 r@ read-line throw while
  here swap scan-chars repeat r> 2drop ;

s" input" r/o open-file throw scan-all-muls
." Part 1: " sum1 ? cr
." Part 2: " sum2 ? cr
bye

