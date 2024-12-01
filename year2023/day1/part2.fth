\ Advent of Code 2023, Day 1 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part2.fth

include common.fth

: equal? ( c-addr1 c-addr2 u -- b )
  \ Determines if c-addr1 and c-addr2 point to u equivalent characters.
  0 do
  2dup c@ swap c@ <> if
  2drop false unloop exit then
  1+ swap 1+
  loop 2drop true ;

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
  -1 +loop drop 0 ;

: digit-search ( beg end inc -- n )
  -rot swap do
  i digit? dup 0= if drop i string-digit? then
  dup if nip unloop exit then drop
  dup +loop drop 0 ;

: first-digit ( c-addr u -- n )
  \ Searches for the first digit character or written digit to occur in the
  \ given string. If no digit is found, returns zero.
  to-range 1 digit-search ;

: last-digit ( c-addr u -- n )
  \ Searches for the last digit character or written digit to occur in the
  \ given string. If no digit is found, returns zero.
  to-range 1- swap -1 digit-search ;

: make-number-and-add-to-sum ( sum c-addr u -- sum )
  \ Makes a number out of the found first and last digits, adding it to the sum.
  2dup first-digit
  -rot last-digit
  make-number + ;

0 for-each-input make-number-and-add-to-sum . cr

