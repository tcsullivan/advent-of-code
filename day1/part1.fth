\ Advent of Code 2023, Day 1 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part1.fth

variable sum

: next-input ( -- c-addr u )
  \ Reads a line of input from stdin.
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

: first-digit ( c-addr u -- n )
  \ Searches for the first digit character to occur in the given string.
  \ If no digit is found, returns zero.
  0 do
  dup i + c@
  dup digit? if nip unloop exit then
  drop loop
  drop 0 ;

: last-digit ( c-addr u -- n )
  \ Searches for the last digit character to occur in the given string.
  \ If no digit is found, returns zero.
  1- 0 swap do
  dup i + c@
  dup digit? if nip unloop exit then
  drop -1 +loop
  drop 0 ;

: make-number ( n n -- n )
  \ Given "tens" and "ones" digit characters, produces the integer value
  \ represented by these characters. 
  \ Does not follow BASE.
  [char] 0 tuck - -rot - 10 * + ;

: do-thing
  \ Does the part 1 thing: Finds first and last digit, makes number out of
  \ them, and adds that number to the sum.
  2dup first-digit
  -rot last-digit
  make-number sum +! ;

0 sum !
for-each-input do-thing
sum ? cr

