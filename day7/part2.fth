\ Advent of Code 2023, Day 7 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend each line with "hand: "

include common.fth

: joker? pad@ 0= ;

\ Extend hand type words to support jokers:

:noname
  [ ' five-of-a-kind defer@ compile, ]
  0 1 match? 1 2 match? and 2 3 match? and   4 joker? and or
  0 1 match? 1 2 match? and                  3 joker? and or
  0 1 match?                                 2 joker? and or
                                             1 joker?     or ;
is five-of-a-kind

:noname
  [ ' four-of-a-kind defer@ compile, ]
  0 1 match? 1 2 match? and   4 joker? and or
  1 2 match? 2 3 match? and   4 joker? and or
  0 1 match?                  3 joker? and or
  1 2 match?                  3 joker? and or
                              2 joker?     or ;
is four-of-a-kind

:noname
  [ ' three-of-a-kind defer@ compile, ]
  0 1 match?   4 joker? and or
  1 2 match?   4 joker? and or
  2 3 match?   4 joker? and or
               3 joker?     or ;
is three-of-a-kind

:noname
  [ ' one-pair defer@ compile, ]
    4 joker? or ;
is one-pair

:noname
  case
  [char] A of 12 endof
  [char] K of 11 endof
  [char] Q of 10 endof
  [char] J of  0 endof
  [char] T of  9 endof
  dup [char] 0 - 1 - swap
  endcase ;
is card-to-b13

include input

depth sort \ All hands are on deck! (stack)
score-hands . cr bye

