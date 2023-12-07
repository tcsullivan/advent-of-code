\ Advent of Code 2023, Day 7 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend each line with "hand: "

\ https://arxiv.org/pdf/1605.06640.pdf
: bubble
  dup if >r
  over over < if swap then
  r> swap >r 1- recurse r>
  else drop then ;

\ https://arxiv.org/pdf/1605.06640.pdf
: sort ( a1 ... an n -- sorted )
  1- dup 0 do >r r@ bubble r> loop drop ;

: dup-hand
  5 0 do 4 pick loop ;

: drop-hand 2drop 2drop drop ;

: hand-to-pad
  5 0 do pad i cells + ! loop ;

: pad@ cells pad + @ ;

: match? ( n1 n2 -- b )
  pad@ swap pad@ = ;

: five-of-a-kind
  hand-to-pad
  0 1 match? 1 2 match? and 2 3 match? and 3 4 match? and ;

: four-of-a-kind
  hand-to-pad
  0 1 match? 1 2 match? and 2 3 match? and
  1 2 match? 2 3 match? and 3 4 match? and or ;

: full-house
  hand-to-pad
  0 1 match? 1 2 match? and 3 4 match? and
  0 1 match? 2 3 match? and 3 4 match? and or ;

: three-of-a-kind
  hand-to-pad
  0 1 match? 1 2 match? and
  1 2 match? 2 3 match? and or
  2 3 match? 3 4 match? and or ;

: two-pair
  hand-to-pad
  0 1 match? 2 3 match? and
  1 2 match? 3 4 match? and or
  0 1 match? 3 4 match? and or ;

: one-pair
  hand-to-pad
  0 1 match?
  1 2 match? or
  2 3 match? or
  3 4 match? or ;

13 13 13 13 13 * * * * constant bonus

: get-score-bonus ( hand... -- score )
  dup-hand five-of-a-kind  if drop-hand bonus 6 * exit then
  dup-hand four-of-a-kind  if drop-hand bonus 5 * exit then
  dup-hand full-house      if drop-hand bonus 4 * exit then
  dup-hand three-of-a-kind if drop-hand bonus 3 * exit then
  dup-hand two-pair        if drop-hand bonus 2 * exit then
  dup-hand one-pair        if drop-hand bonus     exit then
  drop-hand 0 ;

: card-to-b13 ( n -- n )
  case
  [char] A of 12 endof
  [char] K of 11 endof
  [char] Q of 10 endof
  [char] J of  9 endof
  [char] T of  8 endof
  dup [char] 0 - 2 - swap
  endcase ;

: hand: ( -- n )
  bl parse drop pad !
  5 0 do pad @ 4 i - chars + c@ card-to-b13 loop
  dup-hand 0 5 0 do 13 * + loop >r
  5 sort swap 2swap swap 4 roll \ sorted-reversed...
  get-score-bonus r> +
  10000 * 0 s>d bl parse >number 2drop d>s + ;

: score-hands
  0 depth 1 do swap 10000 mod i * + loop ;

include input

depth sort
score-hands . cr bye

