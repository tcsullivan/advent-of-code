: s=         tuck compare 0= ;
: get-number 99 0 s>d 2swap >number rot 2drop ;

: scan-chars ( addr u -- )
  0 0 2swap 1 -rot over + swap do
  i s" do()"    s= if drop 1 then
  i s" don't()" s= if drop 0 then
  i s" mul("    s= if
    i 4 + get-number dup c@ [char] , = if
      1+ get-number c@ [char] ) = if
        rot >r * tuck \ s2 x s1 x | en
        + -rot r@ * + swap r>
      else 2drop then
    else 2drop then
  then loop drop ;

s" input" r/o open-file throw
here over file-size throw d>s
rot read-file throw
here swap scan-chars

." Part 1: " . cr
." Part 2: " . cr
bye

