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

: i|  s"   ~    ~    ~    ~    ~  " ;
: i7  s"           ~~~    ~    ~  " ;
: iFF s"             ~~~  ~    ~  " ;
: iL  s"   ~    ~    ~~~          " ;
: iJ  s"   ~    ~  ~~~            " ;
: i-  s"           ~~~~~          " ;
: i.  s"                          " ;

create image width @ height @ * 25 * allot

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

: travel-all ( -- n )
  0 pad ! start 2@ begin
  2dup travel
  2swap prev 2!
  1 pad +!
  2dup start 2@ coord= until 2drop pad @ ;

: blit ( ia c-addr u -- )
  0 do \ ia id
  dup i + c@ \ ia id P
  2 pick
  i 5 / width @ 5 * * +
  i 5 mod +
  c! loop 2drop ;

: icoord                        5 * swap width @ 25 * * + ;
: image@                        icoord image + c@ ;
: image!                        icoord image + c! ;
: go-north ( y x -- y x )       width @ 5 * - ;
: go-south ( y x -- y x )       width @ 5 * + ;
: go-east ( y x -- y x )        1+ ;
: go-west ( y x -- y x )        1- ;
: valid-c?                      dup 0 >= swap width @ 5 * < and ;
: valid? ( i -- b )             width @ 5 * /mod valid-c? swap valid-c? and ;

: draw ( y x -- )
  2dup icoord image +
  -rot map@ case
  [char] | of i| blit endof
  [char] 7 of i7 blit endof
  [char] F of iFF blit endof
  [char] L of iL blit endof
  [char] J of iJ blit endof
  [char] - of i- blit endof
  [char] . of i. blit endof
  endcase ;

: fill ( i -- )
  255 over image + c!
  dup valid? if dup go-north image + c@ bl = if dup go-north recurse then then
  dup valid? if dup go-south image + c@ bl = if dup go-south recurse then then
  dup valid? if dup go-east  image + c@ bl = if dup go-east  recurse then then
  dup valid? if dup go-west  image + c@ bl = if dup go-west  recurse then then
  drop ;

: filled? ( i -- )
  dup      c@ bl =
  over 4 + c@ bl = and
  over width @ 5 * 4 * +     c@ bl = and
  swap width @ 5 * 4 * + 4 + c@ bl = and ;

: build-image                   height @ 0 do width @ 0 do
                                j i draw
                                loop loop ;
: dump-image                    width @ height @ * 25 * 0 do
                                image i + c@ emit loop ;
: count-image                   0 pad ! height @ 0 do width @ 0 do
                                j i icoord image + filled? pad +!
                                loop loop pad @ negate ;

find-start start 2!

." Part 1: " travel-all 2/ . cr

build-image
start 2@ icoord image + iFF blit \ 'F' is the correct piece for our start (TODO automate)
start 2@ icoord go-east go-east go-east go-south go-south go-south fill
." Part 2: " count-image . cr

bye
