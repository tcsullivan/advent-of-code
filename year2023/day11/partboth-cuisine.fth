\ Advent of Code twenty-twenty-three, Day eleven both parts
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

: inc true negate + ;
: dec true + ;
: not false = ;

here false , false , false inc , false , false , false ,

: width             depth dec pick ;
: height            depth dec pick cell+ ;
: empty-multiplier  depth dec pick cell+ cell+ ;
: empty-rows        depth dec pick cell+ cell+ cell+ ;
: empty-cols        depth dec pick cell+ cell+ cell+ cell+ ;
: _map              depth dec pick cell+ cell+ cell+ cell+ cell+ ;

: map:  bl parse width @ not if dup width ! then here over allot swap move ;

\ Build the map and calculate its height.
false width !
here _map !
include input
here _map @ - width @ / height !
: map _map @ ;

: nine+ inc inc inc inc inc inc inc inc inc ;
: ten* false inc nine+ * ;
: ddup                          over over ;
: dddup                         false inc inc pick false inc inc pick false inc inc pick ;
: ddddup                        false inc inc inc pick false inc inc inc pick
                                false inc inc inc pick false inc inc inc pick ;
: ddrop                         drop drop ;
: sswap                         swap >r -rot r> -rot ;
: within? ( u l n -- b )        tuck < -rot > and ;
: maxswap                       ddup < if swap then ;
: save-stack                    false do , loop ;

: to-idx ( y x -- i )           width @ rot * + ;
: map@ ( y x -- n )             to-idx map + c@ ;
: empty? ( y x -- b )           map@ [char] . = ;
: find-next ( y x -- y x )      height @ rot ?do width @ swap ?do
                                j i empty? not if j i unloop unloop exit then
                                loop false loop drop true true ;
: find-empty-rows               height @ false do true width @ false do
                                j i empty? and loop if i then loop ;
: find-empty-cols               width @ false do true height @ false do
                                i j empty? and loop if i then loop ;

here empty-rows ! find-empty-rows depth dec save-stack true ,
here empty-cols ! find-empty-cols depth dec save-stack true ,

: count-within ( u l a -- n )   false >r begin
                                dup @ true > while
                                dddup @ within? if r> inc >r then
                                cell+ repeat ddrop drop r> ;
: empty-count ( u l a -- n )    count-within empty-multiplier @ * ;
: distance ( y x y x -- n )     rot ddup - abs >r
                                sswap swap ddup - abs >r
                                maxswap empty-rows @ empty-count >r
                                maxswap empty-cols @ empty-count
                                r> + r> + r> + ;
: sum-next-dists ( y x -- n )   false >r ddup begin
                                inc find-next dup false >= while
                                ddddup distance r> + >r repeat ddrop ddrop r> ;
: sum-all-distances             false >r false false begin
                                inc find-next dup false >= while
                                ddup sum-next-dists r> + >r repeat ddrop r> ;

." Part " false inc . ." : " sum-all-distances . cr
false nine+ ten* nine+ ten* nine+ ten* nine+ ten* nine+ ten* nine+ empty-multiplier !
." Part " false inc inc . ." : " sum-all-distances . cr
bye
