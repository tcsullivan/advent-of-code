: next-input ( -- c-addr u )
  \ Reads a line of input from stdin.
  pad 80 0 fill
  pad dup 80 stdin read-line 2drop ;

: for-each-input ( -- )
  \ Collects next execution token and executes it for each result of
  \ next-input with positive u.
  ' >r begin
  next-input
  dup 0<> while
  r@ execute repeat
  2drop r> drop ;

: digit? ( n -- b )
  \ Determines if the given character is a digit.
  \ Does not follow BASE.
  c@ dup dup [char] 0 >= swap [char] 9 <= and 0=
  if drop 0 then ;

: to-range
  over + ;

: make-number ( n n -- n )
  \ Given "tens" and "ones" digit characters, produces the integer value
  \ represented by these characters. 
  \ Does not follow BASE.
  [char] 0 tuck - -rot - 10 * + ;

