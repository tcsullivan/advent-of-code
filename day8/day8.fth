include ../common.fth

create antilist 2 2000 * allot
create antlist  3 1000 * allot
0 value anticount
0 value antcount
0 value height
0 value width

: in-map? ( x y -- b )      2dup 0>= swap 0>= and >r
                            height < swap width < and r> and ;

: 2c@                       dup c@ swap 1+ c@ ;
: 2c!                       tuck c! 1+ c! ;

: get-ant  ( n -- ant )     3 * antlist + ;
: get-anti ( n -- y x )     2* antilist + ;
: ant-xy   ( ant -- x y )   1+ 2c@ ;
: anti-xy  ( n -- y x )     get-anti 2c@ swap ;
: new-ant  ( x y n -- )     antcount  dup 1+ to antcount  get-ant tuck c! 1+ 2c! ;
: new-anti ( y x -- )       anticount dup 1+ to anticount get-anti 2c! ;
: add-anti ( y x -- )       anticount 0 ?do 2dup i anti-xy 2=
                            if unloop 2drop exit then loop new-anti ;
: insert-anti ( y x -- )    2dup in-map? dup >r if add-anti else 2drop then r> ;
: ants>antis  ( -- )        antcount 0 ?do i get-ant ant-xy add-anti loop ;

: ant-match? ( a1 a2 -- b ) c@ swap c@ = ;
: ant-dist ( a1 a2 -- n n ) ant-xy rot ant-xy rot swap - -rot - swap ;

: antinode ( xy xy -- xy )  rot + >r + r> ;
: flip-antinode             negate swap negate swap ;

: find-ants ( c-addr u -- ) dup to width
                            0 ?do dup i + c@ dup [char] . <> if
                            height i rot new-ant else drop then
                            loop drop height 1+ to height ;

: each-ant-pair antcount 1- 0 ?do i get-ant
                antcount i 1+ ?do i get-ant
                2dup ant-match? if 2dup 4 pick execute then
                drop loop drop loop drop ;
: try-anti      rot ant-xy 2over antinode insert-anti drop ;
: try-all-antis rot ant-xy begin 2over antinode 2dup insert-anti 0= until 2drop ;
: initial-scan  2dup ant-dist try-anti      flip-antinode try-anti      2drop ;
: full-scan     2dup ant-dist try-all-antis flip-antinode try-all-antis 2drop ;

open-input ' find-ants each-line
' initial-scan each-ant-pair ." Part 1: " anticount . cr
ants>antis
' full-scan    each-ant-pair ." Part 2: " anticount . cr
bye

