include ../common.fth

0 value width
1 value height
0 value map

: map-do   postpone height postpone false postpone do
           postpone width  postpone false postpone do
           postpone j postpone i ; immediate
: map-loop postpone loop postpone loop ; immediate

: read-first ( fd -- c-addr ) input-line if dup to width allot else abort then ;
: save-line  ( c-addr u -- )  allot drop height 1+ to height ;
: map@       ( j i -- ch )    swap width * + map + c@ ;
: dump-map   ( -- )           map-do map@ emit loop cr loop ;

: row-area ( id row -- area )
  0 swap width * map + width over + swap do
  over i c@ = + loop negate nip ;
: row-peri ( id row -- peri )
  0 0 rot width * map + width over + swap do
  2 pick i c@ = \ peri flag =
  tuck xor if swap 1+ swap then
  loop if 1+ then ;

variable peri
variable area
: stat-all ( id -- peri area )
  0 peri ! 0 area !
  0 swap \ darea id
  height 0 do
  dup i row-peri peri +!
      i row-area dup area +!
  dup >r rot - abs peri +! r> swap
  loop nip height 1- row-area peri +!
  peri @ area @ ;

: stat-everything
  0 [char] Z [char] A do
  i stat-all
  ?dup if 2dup / dup . rot swap / * dup . i emit cr +
  else drop then loop ;
 
open-input dup read-first to map
' save-line each-line

dump-map
stat-everything . cr
bye
