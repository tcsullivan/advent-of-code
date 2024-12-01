\ Advent of Code 2023, Day 2 Part 1
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\ 
\ Usage: gforth part1.fth

: Game ( -- game-id valid? )
  0 s>d              \ Accumulator for >NUMBER
  [char] : parse     \ Parse game ID
  >number 2drop drop \ Convert ID string to single-cell number
  true ;             \ Push game valid boolean

12 constant red-max
13 constant green-max
14 constant blue-max

( valid? -- valid? )
: red,   red-max   <= and ;
: green, green-max <= and ;
: blue,  blue-max  <= and ;
: red;   red,   ;
: green; green, ;
: blue;  blue,  ;

( sum game-id valid? -- sum )
: add-sum if + else drop then ;
: red     red,   add-sum ;
: green   green, add-sum ;
: blue    blue,  add-sum ;

0 \ Initial ID sum

include input

. cr \ Print ID sum
bye

