include ../common.fth

0 value width
1 value height
0 value wordmap

: xmas?  ( c-addr -- b )            dup  s" XMAS"  tuck compare 0=
                                    swap s" SAMX"  tuck compare 0= or ;
: x-mas? ( c-addr -- b )            dup  s" AMSMS" tuck compare 0=
                                    over s" ASSMM" tuck compare 0= or
                                    over s" ASMSM" tuck compare 0= or
                                    swap s" AMMSS" tuck compare 0= or ;
: +xmas?     ( n c-addr -- n )      xmas? if 1+ then ;
: -xmas      ( n -- n )             3 - ;

: read-first ( fd -- c-addr )       input-line if dup to width allot
                                    else abort then ;
: save-line  ( c-addr u -- )        allot drop height 1+ to height ;

: to-map     ( j i -- c-addr )      swap width * + wordmap + ;
: search-horiz                      0 height 0 do width -xmas 0 do
                                    j i to-map +xmas? loop loop ;
: search-vert                       0 height -xmas 0 do width 0 do
                                    j i to-map
                                    4 0 do
                                    dup width i * + c@ here i + c! loop
                                    drop here +xmas? loop loop ;
: search-\                          0 height -xmas 0 do width -xmas 0 do
                                    j i to-map
                                    4 0 do
                                    dup width i * + i + c@ here i + c! loop
                                    drop here +xmas? loop loop ;
: search-/                          0 height -xmas 0 do width 3 do
                                    j i to-map
                                    4 0 do
                                    dup width i * + i - c@ here i + c! loop
                                    drop here +xmas? loop loop ;
: to-x-mas                          dup c@ here c!
                                    dup 1- dup width - c@ here 1 + c!
                                               width + c@ here 2 + c!
                                        1+ dup width - c@ here 3 + c!
                                               width + c@ here 4 + c! here ;
: search-x                          0 height 1- 1 do width 1- 1 do
                                    j i to-map to-x-mas x-mas? if 1+ then loop loop ;

open-input
dup read-first to wordmap
' save-line each-line
." Dimensions: " width . ." x " height . cr
search-horiz search-vert search-\ search-/ + + + ." Part 1: " . cr
search-x ." Part 2: " . cr
bye

