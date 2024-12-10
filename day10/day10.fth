include ../common.fth

0 value width
1 value height
0 value topmap
false value distinct

: read-first ( fd -- c-addr )  input-line if dup to width allot
                               else abort then ;
: save-line  ( c-addr u -- )   allot drop height 1+ to height ;
: to-map     ( j i -- c-addr ) swap width * + topmap + ;
: dump-map                     height 0 do width 0 do
                               j i to-map c@ emit space loop cr loop ;

open-input dup read-first to topmap
' save-line each-line
create scores width height * cells allot

: mark-nine here -rot , , -1 , ;
: score     cells swap cells width * + scores + ;
: score!    score ! ;
: score@    score @ ;
: at?       to-map c@ = ;
: score,    ( d s -- )
            distinct if nip else
            here rot ?do dup 2@ i 2@ 2=
            if unloop drop exit then loop
            then dup @ , cell+ @ , ;
: scores,   ( d sy sx -- )
            score@ begin dup @ 0>= while
            2dup score, 2 cells +
            repeat 2drop ;

: init-scores
  height 0 do width 0 do [char] 9 j i at? if
  j i mark-nine else 0 then j i score! loop loop ;
: calc-score
  score@ ?dup 0= if 0 exit then
  0 swap begin dup @ 0>= while
  swap 1+ swap 2 cells + repeat drop ;
: score-n ( ch -- )
  height 0 do width 0 do dup j i at? if
  here j i score!
  0 i         < if dup 1+ j i 1- at? if j i score@ j i 1- scores, then then
  0 j         < if dup 1+ j 1- i at? if j i score@ j 1- i scores, then then
  i width  1- < if dup 1+ j i 1+ at? if j i score@ j i 1+ scores, then then
  j height 1- < if dup 1+ j 1+ i at? if j i score@ j 1+ i scores, then then
  -1 ,
  then loop loop drop ;
: dump-scores
  height 0 do width 0 do j i calc-score . loop cr loop ;
: score-all
  [char] 0 [char] 8 do i score-n -1 +loop ;
: trailhead-score
  0 height 0 do width 0 do [char] 0 j i at? if
  j i calc-score + then loop loop ;

init-scores false to distinct score-all
." Part 1: " trailhead-score . cr
init-scores true to distinct score-all
." Part 2: " trailhead-score . cr
bye

