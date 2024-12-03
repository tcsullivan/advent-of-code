-1 value mul-start
-1 value mul-end
 1 value enabled
variable sum

: mul?   ( addr -- b ) s" mul("    tuck compare 0= ;
: do?    ( addr -- b ) s" do()"    tuck compare 0= ;
: don't? ( addr -- b ) s" don't()" tuck compare 0= ;

: reset-mul     -1 to mul-start -1 to mul-end ;
: mul-len       mul-end mul-start - 1+ ;
: advance       rot over + -rot - ;
: get-number    0 0 2swap >number 2>r drop 2r> ;

: check-mul ( addr -- )
  mul-len 0< if drop exit then
  mul-start + dup mul? if
    mul-len 4 advance get-number
    over c@ [char] , = if
      1 advance get-number
      1 = swap c@ [char] ) = and if
        enabled * * sum +!
      else 2drop then
    else 2drop drop then
  else drop then ;

: handle-char ( addr i ch -- )
  case
  [char] m of to mul-start drop endof
  [char] ) of to mul-end check-mul reset-mul endof
  >r 2drop r>
  endcase ;

: scan-part1 ( addr u -- )
  reset-mul 0 do dup i + c@ over i rot handle-char loop drop ;

: scan-part2 ( addr u -- )
  reset-mul 0 do dup i +
  dup do? if 1 to enabled then
  dup don't? if 0 to enabled then
  c@ over i rot handle-char loop drop ;

: scan-all-muls ( fd xt -- )
  0 sum ! begin here 4096 chars 2dup 0 fill
  3 pick read-line throw while
  here swap 2 pick execute
  repeat 2drop drop sum @ ;

s" input" r/o open-file throw
dup ' scan-part1 scan-all-muls ." Part 1: " . cr
dup 0 s>d rot reposition-file throw
    ' scan-part2 scan-all-muls ." Part 2: " . cr
bye

