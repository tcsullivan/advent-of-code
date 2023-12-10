\ Advent of Code 2023, Day 10 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all lines with "map: "

 variable width    0 width   !
 variable height   0 height  !
2variable start  0 0 start  2!
2variable prev   0 0 prev   2!

create north char | c, char 7 c, char F c, char S c,
create south char | c, char L c, char J c, char S c,
create east  char - c, char 7 c, char J c, char S c,
create west  char - c, char L c, char F c, char S c,

: map:                          bl parse
                                width @ 0= if dup width ! then
                                here over allot swap move ;

create map
include input
here map - width @ / height !

: coord ( y x -- i )            width @ rot * + ;
: coord= ( y x y x -- b )       rot = -rot = and ;
: map@ ( y x -- n )             coord map + c@ ;
: map! ( n y x -- )             coord map + c! ;
: go-north ( y x -- y x )       swap 1- swap ;
: go-south ( y x -- y x )       swap 1+ swap ;
: go-east ( y x -- y x )        1+ ;
: go-west ( y x -- y x )        1- ;
: new? ( y x -- b )             prev 2@ coord= 0= ;

: dir? ( y x a -- b )           >r map@ r> 4 0 do
                                2dup i + c@ = if 2drop true unloop exit then
                                loop 2drop false ;

: try-north? ( y x -- b )       2dup south dir? -rot go-north north dir? and ;
: try-south? ( y x -- b )       2dup north dir? -rot go-south south dir? and ;
: try-east? ( y x -- b )        2dup west  dir? -rot go-east east dir? and ;
: try-west? ( y x -- b )        2dup east  dir? -rot go-west west dir? and ;

: find-start ( -- y x )         height @ 0 do width @ 0 do
                                j i map@ [char] S = if
                                j i unloop unloop exit then
                                loop loop ;

: travel ( y x -- y x )
  2dup try-north? if 2dup go-north new? if go-north exit then then
  2dup try-south? if 2dup go-south new? if go-south exit then then
  2dup try-east?  if 2dup go-east  new? if go-east  exit then then
  2dup try-west?  if 2dup go-west  new? if go-west  exit then then ;

: mark ( y x -- )               2dup map@ [char] S <> if
                                bl -rot map! else 2drop then ;

: count-pipes ( -- n )          0 pad ! do 2dup do j i map@ bl <> pad +!
                                loop loop 2drop pad @ negate ;

\ Dirty trick: https://www.reddit.com/r/adventofcode/comments/18ez5jb/2023_day_10_part_2_shortcut_solution_using_shape/
\ Enclosed pipes are constrained to an inner square.
: find-enclosed ( -- n )        width @ 4 / dup 3 * swap
                                height @ 4 / dup 3 * swap
                                count-pipes ;

: travel-all ( -- n )
  0 pad ! start 2@ begin
  2dup travel
  2swap 2dup mark prev 2!
  1 pad +!
  2dup start 2@ coord= until 2drop pad @ ;

find-start start 2!
." Part 1: " travel-all 2/ . cr
." Part 2: " find-enclosed . cr
bye

