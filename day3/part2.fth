include common.fth

variable sum 0 sum !

: mul-and-sum
  dup pad - 2 cells = if
  dup @ swap 1 cells - @ * sum +! else drop then ;

: search-schematic
  schheight 1- 1
  schwidth  1- 1
  do 2dup do
  j i sch@ [char] * = if
  j i find-numbers mul-and-sum then
  loop loop 2drop ;

search-schematic
sum ? cr
bye
