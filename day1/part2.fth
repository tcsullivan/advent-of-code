\ Advent of Code 2023, Day 1 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part2.fth

variable sum

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

: equal? ( c-addr1 c-addr2 u -- b )
  \ Determines if c-addr1 and c-addr2 point to u equivalent characters.
  0 do
  2dup c@ swap c@ <> if unloop 2drop false exit then
  char+ swap char+ loop 2drop true ;

: string-digit? ( c-addr -- n )
  \ Determines if a written digit exists at c-addr. If yes, returns the digit's
  \ character representation; otherwise, returns -1.
  dup s" zero"  equal? if drop [char] 0 exit then
  dup s" one"   equal? if drop [char] 1 exit then
  dup s" two"   equal? if drop [char] 2 exit then
  dup s" three" equal? if drop [char] 3 exit then
  dup s" four"  equal? if drop [char] 4 exit then
  dup s" five"  equal? if drop [char] 5 exit then
  dup s" six"   equal? if drop [char] 6 exit then
  dup s" seven" equal? if drop [char] 7 exit then
  dup s" eight" equal? if drop [char] 8 exit then
  dup s" nine"  equal? if drop [char] 9 exit then
  drop -1 ;


: first-digit ( c-addr u -- n )
  \ Searches for the first digit character or written digit to occur in the
  \ given string. If no digit is found, returns zero.
  0 do
  dup c@ dup digit? if nip unloop exit then drop
  dup string-digit? dup 0 >= if nip unloop exit then drop
  char+ loop drop 0 ;

: last-digit ( c-addr u -- n )
  \ Searches for the last digit character or written digit to occur in the
  \ given string. If no digit is found, returns zero.
  1- tuck + swap
  0 swap do
  dup c@ dup digit? if nip unloop exit then drop
  dup string-digit? dup 0 >= if nip unloop exit then drop
  1- -1 +loop drop 0 ;

: make-number ( n n -- n )
  \ Given "tens" and "ones" digit characters, produces the integer value
  \ represented by these characters. 
  \ Does not follow BASE.
  [char] 0 tuck - -rot - 10 * + ;

: do-thing
  \ Does the thing: Finds first and last digit, makes number out of them, and
  \ adds that number to the sum.
  2dup first-digit
  -rot last-digit
  make-number sum +! ;

0 sum !
for-each-input do-thing
sum ? cr

