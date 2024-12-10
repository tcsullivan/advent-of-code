include ../common.fth

0 value width
1 value height
0 value topmap
false value keep-dups

: read-first ( fd -- c-addr )  input-line if dup to width allot else abort then ;
: save-line  ( c-addr u -- )   allot drop height 1+ to height ;
: to-map     ( j i -- c-addr ) swap width * + topmap + ;
: dump-map   ( -- )            height 0 do width 0 do j i to-map c@ emit loop cr loop ;

open-input dup read-first to topmap
' save-line each-line
create scores width height * cells allot

: init-score  here -rot , , -1 , ;
: score       cells swap cells width * + scores + ;
: score!      score ! ;
: score@      score @ ;
: at?         to-map c@ = ;
: score,      ( d s -- )
              keep-dups if nip else
              here rot ?do dup 2@ i 2@ 2= if unloop drop exit then loop
              then dup @ , cell+ @ , ;
: scores,     ( d sy sx -- )
              score@     begin dup @ 0>= while 2dup score, 2 cells + repeat 2drop ;
: calc-score  score@ dup begin dup @ 0>= while 2 cells + repeat swap - 2 cells / ;
: dump-scores height 0 do width 0 do j i calc-score . loop cr loop ;

: init-scores
  height 0 do width 0 do [char] 9 j i at? if
  j i init-score else 0 then j i score! loop loop ;
: score-n ( ch -- )
  height 0 do width 0 do dup j i at? if
  dup 1+ here tuck j i score!
  0 i         < if dup j i 1- at? if over j i 1- scores, then then
  0 j         < if dup j 1- i at? if over j 1- i scores, then then
  i width  1- < if dup j i 1+ at? if over j i 1+ scores, then then
  j height 1- < if dup j 1+ i at? if over j 1+ i scores, then then
  -1 , 2drop
  then loop loop drop ;
: score-all   [char] 0 [char] 8 do i score-n -1 +loop ;
: trailhead-score
  0 height 0 do width 0 do [char] 0 j i at? if j i calc-score + then loop loop ;

." Part 1: " init-scores score-all trailhead-score . cr
true to keep-dups
." Part 2: " init-scores score-all trailhead-score . cr
bye

