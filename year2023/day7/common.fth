\ Advent of Code 2023, Day 7 common code
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend each line with "hand: "

\ Allow each part to define its own character conversion implementation.
defer card-to-b13

\ https://arxiv.org/pdf/1605.06640.pdf
: bubble
  dup if >r 2dup < if swap then r> swap >r 1- recurse r>
  else drop then ;

\ https://arxiv.org/pdf/1605.06640.pdf
: sort ( a1 ... an n -- sorted )
  1- dup 0 do >r r@ bubble r> loop drop ;

: reverse-hand ( 1 2 3 4 5 -- 5 4 3 2 1 )
  swap 2swap swap 4 roll ;

: dup-hand ( hand... -- hand... hand... )
  5 0 do 4 pick loop ;

: drop-hand ( hand... -- )
  2drop 2drop drop ;

: hand-to-pad ( hand... -- )
  pad 5 0 do tuck ! cell+ loop drop ;

: pad@ ( n -- n )
  cells pad + @ ;

: match? ( n1 n2 -- b )
  pad@ swap pad@ = ;

defer five-of-a-kind :noname ( hand... -- b )
  0 1 match? 1 2 match? and 2 3 match? and 3 4 match? and ;
is five-of-a-kind

defer four-of-a-kind :noname ( hand... -- b )
  0 1 match? 1 2 match? and 2 3 match? and
  1 2 match? 2 3 match? and 3 4 match? and or ;
is four-of-a-kind

defer three-of-a-kind :noname ( hand... -- b )
  0 1 match? 1 2 match? and
  1 2 match? 2 3 match? and or
  2 3 match? 3 4 match? and or ;
is three-of-a-kind

: two-pair ( hand... -- b )
  0 1 match? 2 3 match? and
  1 2 match? 3 4 match? and or
  0 1 match? 3 4 match? and or ;

: full-house ( hand... -- b )
  two-pair three-of-a-kind and ;

defer one-pair :noname ( hand... -- b )
  0 1 match?
  1 2 match? or
  2 3 match? or
  3 4 match? or ;
is one-pair

: get-type ( hand... -- type )
  hand-to-pad true case
   five-of-a-kind of 6 endof
   four-of-a-kind of 5 endof
       full-house of 4 endof
  three-of-a-kind of 3 endof
         two-pair of 2 endof
         one-pair of 1 endof
                  >r 0 r> \ default
  endcase ;

: hand: ( -- n )
  bl parse drop                         \ Stack has c-addr of hand
  dup 4 + do i c@ card-to-b13 -1 +loop  \ Push each digit to stack in base 13
  dup-hand 5 sort reverse-hand get-type \ Sort hand and determine its type
  0 6 0 do 13 * + loop                  \ Reduce type and digits to one number
  10000 *                               \ Shift left to make room for score
  0 s>d bl parse >number 2drop d>s + ;  \ Add hand's score

: score-hands ( hands... -- n )
  0 depth 1 do swap 10000 mod i * + loop ;

