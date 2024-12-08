include ../common.fth

create antilist 2 2000 * allot
create antlist  3 1000 * allot
create anticount 0 ,
create antcount 0 ,
create height 0 ,
create width 0 ,

: in-map? ( x y -- b )      2dup 0>= swap 0>= and >r
                            height @ < swap width @ < and r> and ;

: ant-x   ( c-addr -- n )   1+ c@ ;
: ant-y   ( c-addr -- n )   2 + c@ ;
: ant-xy  ( c-addr -- n n ) dup ant-x swap ant-y ;
: get-ant ( n -- c-addr )   3 * antlist + ;
: add-ant ( y x n -- )      antcount @ get-ant
                            tuck c! 1+ tuck c! 1+ c!
                            1 antcount +! ;
: ant-match? ( a1 a2 -- b ) c@ swap c@ = ;
: ant?     ( n -- b )       [char] . <> ;
: ant-dist ( a1 a2 -- n n ) 2dup ant-x swap ant-x - -rot
                            ant-y swap ant-y - ;

: get-anti ( n -- y x )     2* antilist + dup c@ swap 1+ c@ ;
: new-anti ( y x -- )       anticount @ 2* antilist +
                            tuck 1+ c! c! 1 anticount +! ;
: add-anti ( y x -- )       anticount @ 0 ?do
                            2dup i get-anti 2= if unloop 2drop exit then loop 
                            new-anti ;
: insert-anti ( y x -- )    2dup in-map? dup >r if add-anti else 2drop then r> ;
: antinode ( xy xy -- xy )  rot + >r + r> ;
: flip-antinode             negate swap negate swap ;
: ants>antis ( -- )         antcount @ 0 ?do i get-ant ant-xy add-anti loop ;

: gather-ants ( c-addr u -- )
  dup width !
  0 ?do dup i + c@ dup ant? if
  height @ i rot add-ant else drop then
  loop drop 1 height +! ;

: each-ant-pair
  antcount @ 1- 0 ?do i get-ant
  antcount @ i 1+ ?do i get-ant
  2dup ant-match? if 2dup 4 pick execute then
  drop loop drop loop drop ;

: initial-scan  2dup ant-dist
                rot ant-xy 2over antinode insert-anti drop
                flip-antinode
                rot ant-xy 2swap antinode insert-anti drop ;
: full-scan     2dup ant-dist
                rot ant-xy begin 2over antinode 2dup insert-anti 0= until 2drop
                flip-antinode
                rot ant-xy begin 2over antinode 2dup insert-anti 0= until 2drop
                2drop ;

open-input ' gather-ants each-line
' initial-scan each-ant-pair ." Part 1: " anticount ? cr
ants>antis
' full-scan    each-ant-pair ." Part 2: " anticount ? cr
bye

