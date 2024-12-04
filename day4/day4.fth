include ../common.fth

0 value width
1 value height
0 value wordmap

: xmas?        ( c-addr -- b )      dup  s" XMAS"  tuck compare 0=
                                    swap s" SAMX"  tuck compare 0= or ;
: x-mas?       ( c-addr -- b )      dup  s" AMSMS" tuck compare 0=
                                    over s" ASSMM" tuck compare 0= or
                                    over s" ASMSM" tuck compare 0= or
                                    swap s" AMMSS" tuck compare 0= or ;
: +xmas?       ( n c-addr -- n )     xmas? if 1+ then ;
: +x-mas?      ( n c-addr -- n )    x-mas? if 1+ then ;
: +xmas-here?  ( n -- n )           -4 allot here +xmas? ;
: +x-mas-here? ( n -- n )           -5 allot here +x-mas? ;

: read-first   ( fd -- c-addr )     input-line if dup to width allot else abort then ;
: save-line    ( c-addr u -- )      allot drop height 1+ to height ;

: to-map       ( j i -- c-addr )    swap width * + wordmap + ;
: capture-xmas ( c-addr n -- )      4 0 do over c@ c, tuck + swap loop 2drop ;
: word>here    ( j i n -- )         >r to-map r> width + capture-xmas ;
: x-mas>here   ( j i -- )           to-map dup c@ c,
                                    dup 1- dup width - c@ c, width + c@ c,
                                        1+ dup width - c@ c, width + c@ c, ;

: search-horiz ( -- n ) 0 height     0 do width 3 - 0 do j i    to-map    +xmas?       loop loop ;
: search-vert  ( -- n ) 0 height 3 - 0 do width     0 do j i  0 word>here +xmas-here?  loop loop ;
: search-\     ( -- n ) 0 height 3 - 0 do width 3 - 0 do j i  1 word>here +xmas-here?  loop loop ;
: search-/     ( -- n ) 0 height 3 - 0 do width     3 do j i -1 word>here +xmas-here?  loop loop ;
: search-x     ( -- n ) 0 height 1-  1 do width 1-  1 do j i   x-mas>here +x-mas-here? loop loop ;

open-input dup read-first to wordmap
' save-line each-line
." Dimensions: " width . ." x " height . cr
search-horiz search-vert + search-\ + search-/ + ." Part 1: " . cr
search-x ." Part 2: " . cr
bye

