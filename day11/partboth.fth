\ Advent of Code 2023, Day 11 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

variable width
variable height
variable ecount 0 ecount !

\ Collect '#' coordinates while we parse the map.
: map:          bl parse
                width @ 0= if dup width ! then
                0 do dup i + c@ dup c, [char] # = if
                height @ i rot then loop drop 1 height +! ;
: save-stack    0 do , loop ;

\ Build the map and coordinate list.
0 width ! 0 height !
create map
include input
create coords depth save-stack -1 ,

: map@ ( y x -- n )             swap width @ * + map + c@ ;
: empty? ( y x -- b )           map@ [char] . = ;
: find-empty-rows ( -- n... )   height @ 0 do true width @ 0 do
                                j i empty? and loop if i then loop ;
: find-empty-cols ( -- n... )   width @ 0 do true height @ 0 do
                                i j empty? and loop if i then loop ;
: coord+ ( a -- a )             2 cells + ;

create empty-rows find-empty-rows depth save-stack -1 ,
create empty-cols find-empty-cols depth save-stack -1 ,

: count-within ( l u a -- n )   begin 2dup @ < while cell+ repeat
                                nip tuck begin 2dup @ < while cell+ repeat
                                nip swap - 1 cells / ;
: empty-count ( u l a -- n )    >r 2dup > if swap then r> count-within ;
: distance ( y x y x -- n )     >r -rot r> swap
                                2dup - abs >r 2swap 2dup - abs r> + >r
                                empty-rows empty-count -rot
                                empty-cols empty-count + dup ecount +! r> + ;
: sum-next-dists ( y x -- n )   0 >r dup coord+ begin dup @ 0 >= while
                                2dup 2@ rot 2@ distance r> + >r
                                coord+ repeat 2drop r> ;
: sum-all-distances ( -- n )    0 coords begin dup @ 0 >= while
                                dup sum-next-dists rot + swap
                                coord+ repeat drop ;

utime
sum-all-distances
dup ecount @ 999998 * + swap
utime 2swap

." Part 1: " . cr ." Part 2: " . cr
." Time: " 2swap d- d. ." us" cr
bye
