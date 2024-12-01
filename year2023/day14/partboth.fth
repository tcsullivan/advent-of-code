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

create map
include input
create mapbuf width @ height @ * allot
create loads width @ height @ max cells allot

: map@ ( y x -- n )     swap width @ * + map + c@ ;
: map! ( n y x -- )     swap width @ * + map + c! ;
: round? ( y x -- b )   map@ [char] O = ;
: cube? ( y x -- b )    map@ [char] # = ;

: load@ ( u -- n )      cells loads + @ ;
: reduce ( u -- )       -1 loads rot cells + +! ;
: setpot ( n u -- )     loads swap cells + ! ;
: cfill ( a u n -- )    -rot 0 do 2dup ! cell+ loop 2drop ;

: handle-cube ( y x -- ) height @ rot - 1- swap setpot ;
: handle-round ( y x -- ) tuck height @ over load@ -
                        over 2swap [char] . -rot map!
                        [char] O -rot map!
                        reduce ;

: transpose             height @ 0 do width @ 0 do
                        j width @ * i              + map    + c@
                        i width @ * width @ 1- j - + mapbuf + c!
                        loop loop
                        mapbuf map width @ height @ * move
                        width @ height @ width ! height ! ;
: roll-north            loads width @ height @ cfill
                        height @ 0 do width @ 0 do
                        j i round? if j i handle-round else
                        j i cube? if j i handle-cube then then
                        loop loop ;
: ncycle                0 do roll-north transpose loop ;
: cycle                 4 ncycle ;
: score                 height @ 0 over 0 do width @ 0 do
                        j i round? if over + then loop >r 1- r> loop nip ;

\ Find target-th load score by cycling to a steady state, searching for the
\ oscillation period, then fast-forwarding to close behind the target.
: score-target          205 1- 1 do cycle loop cycle score
                        0 begin cycle score 2 pick <> while 1+ repeat nip
                        dup 205 + begin dup target 205 - < while over + repeat nip
.s cr
                        \ dup 190 + >r target r@ - dup rot mod - r@ + r> drop
                        target swap ?do cycle loop score ;

utime
roll-north score transpose 3 ncycle
score-target swap
utime 2swap

." Part 1: " . cr
." Part 2: " . cr
." Time: " 2swap d- d. ." us" cr
.s cr
bye

