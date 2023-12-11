\ Advent of Code 2023, Day 11 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

variable width
variable height

: map:  bl parse width @ 0= if dup width ! then here over allot swap move ;

\ Build the map and calculate its height.
0 width !
create map
include input
here map - width @ / height !

: 3dup                          2 pick 2 pick 2 pick ;
: 4dup                          2over 2over ;
: within? ( u l n -- b )        tuck < -rot > and ;
: maxswap                       2dup < if swap then ;
: save-stack                    0 do , loop ;

: to-idx ( y x -- i )           width @ rot * + ;
: map@ ( y x -- n )             to-idx map + c@ ;
: empty? ( y x -- b )           map@ [char] . = ;
: find-next ( y x -- y x )      height @ rot ?do width @ swap ?do
                                j i empty? 0= if j i unloop unloop exit then
                                loop 0 loop drop -1 -1 ;
: find-empty-rows               height @ 0 do true width @ 0 do
                                j i empty? and loop if i then loop ;
: find-empty-cols               width @ 0 do true height @ 0 do
                                i j empty? and loop if i then loop ;

create empty-rows find-empty-rows depth save-stack -1 ,
create empty-cols find-empty-cols depth save-stack -1 ,
create empty-multiplier 1 ,

: count-within ( u l a -- n )   0 >r begin
                                dup @ -1 > while
                                3dup @ within? if r> 1+ >r then
                                cell+ repeat 2drop drop r> ;
: empty-count ( u l a -- n )    count-within empty-multiplier @ * ;
: distance ( y x y x -- n )     rot 2dup - abs >r
                                2swap swap 2dup - abs >r
                                maxswap empty-rows empty-count >r
                                maxswap empty-cols empty-count
                                r> + r> + r> + ;
: sum-next-dists ( y x -- n )   0 >r 2dup begin
                                1+ find-next dup 0 >= while
                                4dup distance r> + >r repeat 2drop 2drop r> ;
: sum-all-distances             0 >r 0 0 begin
                                1+ find-next dup 0 >= while
                                2dup sum-next-dists r> + >r repeat 2drop r> ;

." Part 1: " sum-all-distances . cr
999999 empty-multiplier !
." Part 2: " sum-all-distances . cr
bye
