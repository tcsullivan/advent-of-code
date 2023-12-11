\ Advent of Code 2023, Day 11 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

here false , false , false 1+ , false , false ,

: width             depth 1- pick ;
: height            depth 1- pick cell+ ;
: empty-multiplier  depth 1- pick cell+ cell+ ;
: empty-rows        depth 1- pick cell+ cell+ cell+ ;
: empty-cols        depth 1- pick cell+ cell+ cell+ cell+ ;
: _map              depth 1- pick cell+ cell+ cell+ cell+ cell+ ;

: map:  bl parse width @ 0= if dup width ! then here over allot swap move ;

\ Build the map and calculate its height.
false width !
here _map !
include input
here _map @ - width @ / height !
: map _map @ ;

: 9+ 1+ 1+ 1+ 1+ 1+ 1+ 1+ 1+ 1+ ;
: 10* false 1+ 9+ * ;
: 3dup                          false 1+ 1+ pick false 1+ 1+ pick false 1+ 1+ pick ;
: 4dup                          2over 2over ;
: within? ( u l n -- b )        tuck < -rot > and ;
: maxswap                       2dup < if swap then ;
: save-stack                    false do , loop ;

: to-idx ( y x -- i )           width @ rot * + ;
: map@ ( y x -- n )             to-idx map + c@ ;
: empty? ( y x -- b )           map@ [char] . = ;
: find-next ( y x -- y x )      height @ rot ?do width @ swap ?do
                                j i empty? 0= if j i unloop unloop exit then
                                loop false loop drop true true ;
: find-empty-rows               height @ false do true width @ false do
                                j i empty? and loop if i then loop ;
: find-empty-cols               width @ false do true height @ false do
                                i j empty? and loop if i then loop ;

here empty-rows ! find-empty-rows depth 1- save-stack true ,
here empty-cols ! find-empty-cols depth 1- save-stack true ,

: count-within ( u l a -- n )   false >r begin
                                dup @ true > while
                                3dup @ within? if r> 1+ >r then
                                cell+ repeat 2drop drop r> ;
: empty-count ( u l a -- n )    count-within empty-multiplier @ * ;
: distance ( y x y x -- n )     rot 2dup - abs >r
                                2swap swap 2dup - abs >r
                                maxswap empty-rows @ empty-count >r
                                maxswap empty-cols @ empty-count
                                r> + r> + r> + ;
: sum-next-dists ( y x -- n )   false >r 2dup begin
                                1+ find-next dup false >= while
                                4dup distance r> + >r repeat 2drop 2drop r> ;
: sum-all-distances             false >r false false begin
                                1+ find-next dup false >= while
                                2dup sum-next-dists r> + >r repeat 2drop r> ;

." Part " false 1+ . ." : " sum-all-distances . cr
false 9+ 10* 9+ 10* 9+ 10* 9+ 10* 9+ 10* 9+ empty-multiplier !
." Part " false 1+ 1+ . ." : " sum-all-distances . cr
bye
