include ../common.fth

0 value W
0 value H
0 value map
0 value best
0 value obest

: >map ( c-addr u -- )  W 0= if dup to W then allot drop H 1+ to H ;
: map@ ( n n -- n )     W * + map + c@ ;
: map! ( n n -- n )     W * + map + c! ;
: .map ( -- )           H 0 do W 0 do i j map@ emit loop cr loop ;
: map-find ( n -- x y ) H 0 do W 0 do i j map@ over =
                        if drop i j unloop unloop exit then loop loop ;

here to map open-input ' >map each-line
create scores W H * cells allot

: init-scores           999999 to best W H * 0 do best scores i cells + ! loop ;
: score@ ( n n -- n )   W * + cells scores + @ ;
: score! ( n n -- n )   W * + cells scores + ! ;

: solve ( n x y -- )
  rot 1+ -rot
  2dup map@ [char] E = if 2drop best min to best exit then
  2dup map@ [char] # = if 3drop exit then
  3dup score@ >=       if 3drop exit then
  3dup score!
  over 0 > if 3dup swap 1- swap recurse then
  over W < if 3dup swap 1+ swap recurse then
  dup  0 > if 3dup      1-      recurse then
  dup  H < if 3dup      1+      recurse then
  3drop ;

create total 0 ,
: solve-all
  H 1- 1 do W 1- 1 do
  i j map@ [char] # = if
    i 1- j    map@ [char] # <>
    i 1+ j    map@ [char] # <> +
    i    j 1- map@ [char] # <> +
    i    j 1+ map@ [char] # <> +
    -1 < if
      [char] . i j map!
      3dup init-scores solve
      obest best - abs 100 >= if 1 total +! then
      [char] # i j map!
    then
  then loop loop 3drop ;

\ .map
-1 char S map-find init-scores solve best to obest
-1 char S map-find solve-all
total ? cr
bye
