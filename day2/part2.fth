variable min-red
variable min-green
variable min-blue

: reset-mins ( -- )
  0 min-red !
  0 min-green !
  0 min-blue ! ;

: power ( -- power )
  min-red @ min-green @ min-blue @ * * ;

: Game ( -- )
  [char] : parse \ Parse game ID
  2drop          \ Discard game ID...
  reset-mins ;   \ Reset minimums

( cube-count -- )
: red,   min-red   @ max min-red   ! ;
: green, min-green @ max min-green ! ;
: blue,  min-blue  @ max min-blue  ! ;
: red;   red,   ;
: green; green, ;
: blue;  blue,  ;

( cube-count -- power )
: red    red;   power ;
: green  green; power ;
: blue   blue;  power ;

( values... -- sum )
: sum-stack depth 1- 0 do + loop ;

include input

sum-stack . cr
bye

