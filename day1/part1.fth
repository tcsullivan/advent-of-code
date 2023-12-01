\ Advent of Code 2023, Day 1 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: cat <input file> | gforth part1.fth

include common.fth

: first-digit ( c-addr u -- n )
  \ Searches for the first digit character to occur in the given string.
  \ If no digit is found, returns zero.
  to-range 1 ['] digit? find-if ;

: last-digit ( c-addr u -- n )
  \ Searches for the last digit character to occur in the given string.
  \ If no digit is found, returns zero.
  to-range 1- swap -1 ['] digit? find-if ;

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

