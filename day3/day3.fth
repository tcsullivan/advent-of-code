-1 value mul-start
-1 value mul-end
false value disabled
variable sum

: s=            tuck compare 0= ;
: reset-mul     -1 to mul-start -1 to mul-end ;
: mul-len       mul-end mul-start - 1+ ;
: advance       rot over + -rot - ;
: get-number    0 s>d 2swap >number 2>r d>s 2r> ;

: check-mul ( addr -- )
  disabled mul-len 0< or       if drop exit then
  mul-start +
  dup s" mul(" s= 0=           if drop exit then
  mul-len 4 advance get-number
  over c@ [char] , <>          if 2drop drop exit then
  1 advance get-number
  1 <> swap c@ [char] ) <> or  if 2drop exit then
  * sum +! ;

: handle-char ( addr i -- )
  2dup + c@ case
  [char] m of to mul-start drop endof
  [char] ) of to mul-end check-mul endof
  >r 2drop r>
  endcase ;
: handle-do's ( addr -- )
  dup s" do()"    s= if false to disabled then
      s" don't()" s= if  true to disabled then ;

: scan-part1 ( addr u -- )
  0 do dup i handle-char loop drop ;

: scan-part2 ( addr u -- )
  0 do dup i 2dup + handle-do's handle-char loop drop ;

: scan-all-muls ( fd xt -- n )
  0 sum ! >r begin here 4096
  2 pick read-line throw while
  here swap r@ reset-mul execute
  repeat 2drop r> drop sum @ ;

s" input" r/o open-file throw
dup ' scan-part1 scan-all-muls ." Part 1: " . cr
dup 0 s>d rot reposition-file throw
    ' scan-part2 scan-all-muls ." Part 2: " . cr
bye

