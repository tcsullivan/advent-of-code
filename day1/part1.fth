\ Advent of Code 2023, Day 1 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part1.fth

include common.fth

: find-if ( beg end inc pred -- n )
  2swap swap do
  i 2dup swap execute
  if nip nip unloop exit then
  drop over +loop 2drop 0 ;

: first-digit ( c-addr u -- n )
  \ Searches for the first digit character to occur in the given string.
  \ If no digit is found, returns zero.
  to-range 1 ['] digit? find-if c@ ;

: last-digit ( c-addr u -- n )
  \ Searches for the last digit character to occur in the given string.
  \ If no digit is found, returns zero.
  to-range 1- swap -1 ['] digit? find-if c@ ;

: make-number-and-add-to-sum ( sum c-addr u -- sum )
  \ Makes a number out of the found first and last digits, adding it to the sum.
  2dup first-digit
  -rot last-digit
  make-number + ;

0 for-each-input make-number-and-add-to-sum . cr

