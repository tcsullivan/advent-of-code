\ Advent of Code 2023, Day 7 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend each line with "hand: "

include common.fth

:noname
  case
  [char] A of 12 endof
  [char] K of 11 endof
  [char] Q of 10 endof
  [char] J of  9 endof
  [char] T of  8 endof
  dup [char] 0 - 2 - swap
  endcase ;
is card-to-b13

include input

depth sort \ All hands are on deck! (stack)
score-hands . cr bye

