
: insert-sort ( addr u -- )
  1 do dup i cells + @ i 1-
  begin 0 over <= dup
  if 2over swap 3 pick cells + @ <
  and then while
  2 pick over cells +
  dup @ swap cell+ !
  1- repeat
  1+ cells 2 pick + !
  loop drop ;

: cell-do ( addr u -- )
  ['] cells compile, ['] over compile,
  ['] + compile, ['] swap compile,
  postpone do ; immediate
: cell-loop cell postpone literal postpone +loop ; immediate
