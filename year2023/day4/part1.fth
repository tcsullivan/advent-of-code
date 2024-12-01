\ Advent of Code 2023, Day 4 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part1.fth

5 constant wincnt
8 constant mycnt

create winners wincnt cells allot

: Card
  [char] : parse 2drop ;

: |
  wincnt 0 do winners i cells + ! loop ;

: contains? ( c-addr u n -- b )
  -rot 0 do
  dup i cells + @
  2 pick = if unloop 2drop true exit then
  loop 2drop false ;

: winner? ( n -- b )
  winners wincnt rot contains? ;

: to-score
  dup if 1 swap 1- lshift then ;

: check
  0 pad !
  mycnt 0 do
  winner? if 1 pad +! then
  loop
  pad @ to-score ;

: sum-stack
  depth 1- 0 do + loop ;

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53 check
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19 check
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1 check
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83 check
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36 check
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11 check

sum-stack . cr bye
