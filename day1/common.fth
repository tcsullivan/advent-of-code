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
  dup [char] 0 >= swap [char] 9 <= and ;

: to-range
  over + ;

: find-if ( beg end inc pred -- n )
  2swap swap do
  i c@ 2dup swap execute
  if nip nip unloop exit then
  drop over +loop 2drop 0 ;

: make-number ( n n -- n )
  \ Given "tens" and "ones" digit characters, produces the integer value
  \ represented by these characters. 
  \ Does not follow BASE.
  [char] 0 tuck - -rot - 10 * + ;

