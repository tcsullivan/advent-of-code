\ Advent of Code 2023, Day 10 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

 variable width    0 width   ! \ map dimensions
 variable height   0 height  !
2variable start  0 0 start  2! \ XY coordinates
2variable prev   0 0 prev   2!

\ Sets of characters you can travel to for the given direction.
create north char | c, char 7 c, char F c, char S c,
create south char | c, char L c, char J c, char S c,
create east  char - c, char 7 c, char J c, char S c,
create west  char - c, char L c, char F c, char S c,

\ Parse the row of map data following this word and store/allocate it to `here`.
: map:                          bl parse
                                width @ 0= if dup width ! then
                                here over allot swap move ;

\ Build the map and calculate its height.
create map
include input
here map - width @ / height !

\ 5x5 bitmaps for each map character. '~' and ' ' for maximum contrast.
: i|  s"   ~    ~    ~    ~    ~  " ;
: i7  s"           ~~~    ~    ~  " ;
: iFF s"             ~~~  ~    ~  " ;
: iL  s"   ~    ~    ~~~          " ;
: iJ  s"   ~    ~  ~~~            " ;
: i-  s"           ~~~~~          " ;
: i.  s"                          " ;

5 constant tiledim
create image width @ height @ tiledim dup * * * allot

\
\ Map words
\

: to-idx ( y x -- i )           width @ rot * + ;
: coord= ( y x y x -- b )       rot = -rot = and ;
: map@ ( y x -- n )             to-idx map + c@ ;
: map! ( n y x -- )             to-idx map + c! ;
: go-north ( y x -- y x )       swap 1- swap ;
: go-south ( y x -- y x )       swap 1+ swap ;
: go-east ( y x -- y x )        1+ ;
: go-west ( y x -- y x )        1- ;
: new? ( y x -- b )             prev 2@ coord= 0= ;

\ Does XY's path continue north/south/east/west?
: path? ( y x dir -- b )        >r map@ r> 4 0 do
                                2dup i + c@ = if 2drop true unloop exit then
                                loop 2drop false ;

\ Check if XY pipe and pipe at N/S/E/W connect.
: try-north? ( y x -- b )       2dup south path? -rot go-north north path? and ;
: try-south? ( y x -- b )       2dup north path? -rot go-south south path? and ;
: try-east? ( y x -- b )        2dup west  path? -rot go-east east path? and ;
: try-west? ( y x -- b )        2dup east  path? -rot go-west west path? and ;

: find-start ( -- y x )         height @ 0 do width @ 0 do
                                j i map@ [char] S = if
                                j i unloop unloop exit then
                                loop loop ;

\ Move XY in the untraveled direction.
: travel ( y x -- y x )
  2dup try-north? if 2dup go-north new? if go-north exit then then
  2dup try-south? if 2dup go-south new? if go-south exit then then
  2dup try-east?  if 2dup go-east  new? if go-east  exit then then
  2dup try-west?  if 2dup go-west  new? if go-west  exit then then ;

\ Travel the entire pipe loop, counting the number of steps taken.
: travel-all ( -- n )
  0 pad ! start 2@ begin
  2dup travel
  2swap prev 2!
  1 pad +!
  2dup start 2@ coord= until 2drop pad @ ;

: identify ( y x -- n )
  0 pad !
  2dup go-north north path? pad +!
  2dup go-south south path? 2 * pad +!
  2dup go-east  east  path? 4 * pad +!
       go-west  west  path? 8 * pad +!
  pad @ case
   -3 of [char] | endof
   -5 of [char] L endof
   -9 of [char] J endof
   -6 of [char] F endof
  -10 of [char] 7 endof
  -12 of [char] - endof
  endcase ;

\
\ Image words
\

: row                           width @ tiledim * ;
: row-                          row - ;
: row+                          row + ;
: col-                          1- ;
: col+                          1+ ;
: valid-c?                      dup 0 >= swap row < and ;
: valid? ( i -- b )             row /mod valid-c? swap valid-c? and ;
: icoord                        tiledim * swap row tiledim * * + ;
: image@                        image + c@ ;
: image!                        icoord image + c! ;

\ Draw the 5x5 tile (c-addr u) to the image address.
: blit ( ia c-addr u -- )
  0 do
  2dup i + c@
  swap i tiledim /mod row * swap + +
  c! loop 2drop ;

\ Draw the symbol on the map at XY to the image.
: draw ( y x -- )
  2dup map@ >r icoord image + r> case
  [char] | of i| blit endof
  [char] 7 of i7 blit endof
  [char] F of iFF blit endof
  [char] L of iL blit endof
  [char] J of iJ blit endof
  [char] - of i- blit endof
  [char] . of i. blit endof
  endcase ;

\ Recursively fill image pixels surrounding image address `i` with white.
: fill-image ( i -- )
  255 over image + c!
  dup row- valid? if dup row- image@ bl = if dup row- recurse then then
  dup row+ valid? if dup row+ image@ bl = if dup row+ recurse then then
  dup col- valid? if dup col- image@ bl = if dup col- recurse then then
  dup col+ valid? if dup col+ image@ bl = if dup col+ recurse then then
  drop ;

\ Check if the tile at image address `i` was flooded by a fill.
: filled? ( i -- )
  dup c@ bl =
  over tiledim 1- + c@ bl = and
  over row tiledim 1- * + c@ bl = and
  swap tiledim 1- + row tiledim 1- * + c@ bl = and ;

: build-image                   height @ 0 do width @ 0 do
                                j i draw
                                loop loop ;
: dump-image                    width @ height @ * tiledim dup * * 0 do
                                i image@ emit loop ;
: count-image                   0 pad ! height @ 0 do width @ 0 do
                                j i icoord image + filled? pad +!
                                loop loop pad @ negate ;

find-start start 2!
." Part 1: " travel-all 2/ . cr

start 2@ 2dup identify -rot map!
build-image
start 2@ icoord 3 + row 3 * + fill-image \ Pipes enclose bottom right corner (TODO automate)
." Part 2: " count-image . cr

bye

