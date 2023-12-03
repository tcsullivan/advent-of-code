include common.fth

: symbol? ( n -- b )
  dup [char] . <> swap digit? 0= and ;

variable sum 0 sum !

: add-to-sum ( n -- )
  begin
  dup @ sum +!
  1 cells -
  dup pad = until drop ;

: search-schematic
  schheight 1- 1
  schwidth  1- 1
  do 2dup do
  j i sch@ symbol? if
  j i find-numbers add-to-sum then
  loop loop 2drop ;

search-schematic
sum ? cr
bye
