\ Advent of Code 2023, Day 1 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part2.fth

include common.fth

: equal? ( c-addr1 c-addr2 u -- b )
  \ Determines if c-addr1 and c-addr2 point to u equivalent characters.
  0 do
  2dup c@ swap c@ <> if unloop 2drop false exit then
  char+ swap char+ loop 2drop true ;

: string-digit? ( c-addr -- n )
  \ Determines if a written digit exists at c-addr. If yes, returns the digit's
  \ character representation; otherwise, returns -1.
  >r
  s" zero" s" one" s" two"   s" three" s" four"
  s" five" s" six" s" seven" s" eight" s" nine"
  r>
  0 9 do
  dup >r -rot equal? r> swap if
  drop i 0 do 2drop loop
  i [char] 0 + unloop exit then
  -1 +loop drop -1 ;

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

variable sum

: do-thing
  \ Does the part 1 thing: Finds first and last digit, makes number out of
  \ them, and adds that number to the sum.
  2dup first-digit
  -rot last-digit
  make-number sum +! ;

0 sum !
for-each-input do-thing
sum ? cr

