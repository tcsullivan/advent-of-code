\ Advent of Code 2023, Day 3 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: gforth partboth.fth

: line: ( -- )
  \ Stores the following word's characters at `here`.
  bl parse here over allot swap move ;

12 constant schwidth
12 constant schheight
create schematic
line: ............
line: .467..114...
line: ....*.......
line: ...35..633..
line: .......#....
line: .617*.......
line: ......+.58..
line: ...592......
line: .......755..
line: ....$.*.....
line: ..664.598...
line: ............

: sch@ ( y x -- n )
  \ Get the schematic character at (x, y).
  schematic + swap schwidth * + c@ ;

: digit? ( n -- b )
  \ True if given number is an ASCII digit.
  dup [char] 0 >= swap [char] 9 <= and ;

: get-number ( y x -- n )
  \ Returns the number which has a digit at (x, y).
  begin
  2dup sch@ digit? while
  1- repeat
  0 >r 1+ begin
  2dup sch@ dup digit? while
  [char] 0 - r> 10 * + >r 1+ repeat
  drop 2drop r> ;

: find-numbers ( y x -- )
  \ Finds numbers surrounding (x, y) at stores them in PAD.
  0 pad ! pad -rot
  dup 2 + swap 1- rot
  dup 2 + swap 1-
  do 2dup do
  j i sch@ digit? if
  rot j i get-number
  over @ over <> if swap cell+ tuck ! else drop then -rot
  then
  loop loop 2drop ;

: search-schematic ( cond action -- )
  \ Searches for schematic characters that satisfy `cond`, finds surrounding
  \ numbers, then calls `action`.
  schheight 1- 1
  schwidth  1- 1
  do 2dup do
  j i sch@ 4 pick execute if
  j i find-numbers 3 pick execute then
  loop loop 2drop 2drop ;

: symbol? ( n -- b )
  \ Symbols are not periods and not digits.
  dup [char] . <> swap digit? 0= and ;

: gear?
  [char] * = ;

variable sum \ Accumulator for part 1 & 2 answers.

: mul-and-sum
  \ If two numbers in PAD, multiply them and add to sum.
  dup pad - 2 cells = if
  dup @ swap 1 cells - @ * sum +! else drop then ;

: add-to-sum ( n -- )
  \ Add numbers in PAD to sum.
  begin
  dup @ sum +!
  1 cells -
  dup pad = until drop ;

\ Part 1: Sum all numbers that touch symbols.
0 sum !
' symbol? ' add-to-sum search-schematic
." Part 1: " sum ? cr

\ Part 2: Sum products of gears with two numbers.
0 sum !
' gear? ' mul-and-sum search-schematic
." Part 2: " sum ? cr

bye

