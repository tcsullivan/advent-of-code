include ../common.fth

36 base !

create dict 1000 allot dict 1000 2 fill
0 value rules
0 value rulesend
true value inits

: read-n 0 s>d 2swap >number rot drop ;
: cnext dup >r - swap r> + swap ;

: arg1   cell+ @ ;
: op     2 cells + @ ;
: arg2   3 cells + @ ;
: dict@ dict + c@ ;
: ready? dict@ 2 < ;

: parse-init ( c-addr u -- )
  read-n rot >r 2 cnext
  read-n 2drop r> dict + c! ;

: parse-rule ( c-addr u -- )
  read-n rot >r 1 cnext
  over c@ dup >r case
  [char] A of 4 cnext endof
  [char] X of 4 cnext endof
  [char] O of 3 cnext endof
  endcase
  read-n rot >r 4 cnext
  read-n 2drop , r> , r> , r> , ;

: parse-all ( c-addr u -- )
  dup 0= if 2drop false to inits exit then
  inits if parse-init else parse-rule then ;

: report ( -- n )
  0 z00 zzz do i ready? if 2* i dict@ or then -1 +loop ; 

: try-rules ( -- )
  begin true
  rulesend rules do
  i @ if
    drop false
    i arg1 ready? i arg2 ready? and if
      i arg1 dict@ i arg2 dict@
      i op case
      [char] A of and endof
      [char] X of xor endof
      [char] O of or endof
      endcase i @ dict + c!
      0 i !
    then
  then
  4 cells +loop
  until ;

here to rules
open-input ' parse-all each-line
here to rulesend

try-rules report
decimal . cr
bye
