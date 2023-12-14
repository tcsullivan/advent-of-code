\ Advent of Code 2023, Day 14 Both parts
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

variable width
variable height
1000000000 constant target

\ Allocates memory at `here` to store the given line of map data.
: map:                  bl parse
                        width @ 0= if dup width ! then
                        here over allot swap move 
                        1 height +! ;
: cfill                 -rot 0 do 2dup ! cell+ loop 2drop ;

create map
include input
create loads width @ height @ max cells allot
create hist 10 cells allot
create hist2 10 cells allot

: map@ ( y x -- n )     swap width @ * + map + c@ ;
: map! ( n y x -- n )   swap width @ * + map + c! ;
: round? ( y x -- b )   map@ [char] O = ;
: cube? ( y x -- b )    map@ [char] # = ;
: move-y ( y x y -- )   over 2swap [char] . -rot map!
                        [char] O -rot map! ;
: move-x ( y x x -- )   2 pick swap 2swap [char] . -rot map!
                        [char] O -rot map! ;

: load@ ( i -- n )      cells loads + @ ;
: reduce ( i -- )       -1 loads rot cells + +! ;
: setpot ( n i -- )     loads swap cells + ! ;

: memcmp ( a1 a2 u -- b )
  0 do 2dup @ swap @ <> if 2drop false unloop exit then loop
  2drop true ;


: roll-north            loads width @ height @ cfill
                        height @ 0 do width @ 0 do
                        j i round? if j i height @ i load@ - move-y i reduce else
                        j i cube? if height @ j - 1- i setpot then then
                        loop loop ;
: roll-west             loads height @ width @ cfill
                        width @ 0 do height @ 0 do
                        i j round? if i j width @ i load@ - move-x i reduce else
                        i j cube? if width @ j - 1- i setpot then then
                        loop loop ;
: roll-south            loads width @ height @ 1- cfill
                        0 height @ 1- do width @ 0 do
                        j i round? if j i i load@ move-y i reduce else
                        j i cube? if j 1- i setpot then then
                        loop -1 +loop ;
: roll-east             loads height @ width @ 1- cfill
                        0 width @ 1- do height @ 0 do
                        i j round? if i j i load@ move-x i reduce else
                        i j cube? if j 1- i setpot then then
                        loop -1 +loop ;
: cycle                 roll-north roll-west roll-south roll-east ;
: score                 0 pad ! height @ dup 0 do width @ 0 do
                        j i round? if dup pad +! then
                        loop 1- loop drop pad @ ;

\ Find target-th load score by cycling to a steady state, searching for the
\ oscillation period, then fast-forwarding to close behind the target.
: score-target          200 1 do cycle loop
                        10 0 do cycle score hist i cells + ! loop
                        1000 0 do
                        hist2 cell+ hist2 9 cells move
                        cycle score hist2 9 cells + !
                        hist hist2 10 memcmp if i leave then loop
                        dup 210 + >r target r@ - dup rot mod - r@ + r> drop
                        target swap ?do cycle loop score ;

utime
roll-north score roll-west roll-south roll-east
score-target swap
utime 2swap

." Part 1: " . cr
." Part 2: " . cr
." Time: " 2swap d- d. ." us" cr
bye

