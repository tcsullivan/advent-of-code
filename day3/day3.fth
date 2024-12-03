true value do?
create sum1 0 ,
create sum2 0 ,

: s=            tuck compare 0= ;
: get-number    99 0 s>d 2swap >number rot 2drop ;

: scan-chars ( addr u -- )
  0 do i over +
  do? over s" do()" s= or
      over s" don't()" s= 0= and to do?
  dup s" mul(" s= if
    4 + get-number dup c@ [char] , = if
      1+ get-number c@ [char] ) = if
        * do? if dup sum2 +! then sum1 +!
      else 2drop then
    else 2drop then
  else drop then
  loop drop ;

: scan-all-muls ( fd -- )
  >r begin here 4096 r@ read-line throw while
  here swap scan-chars repeat r> 2drop ;

s" input" r/o open-file throw scan-all-muls
." Part 1: " sum1 ? cr
." Part 2: " sum2 ? cr
bye

