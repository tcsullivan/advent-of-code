: disk-map s" input" slurp-file 1- ;

: map-file  ( id n -- ) 0 ?do dup , loop drop ;
: map-space ( n -- )    0 ?do  -1 , loop ;

: dump-map over + swap ?do i @ 0< if ." . " else i ? then cell +loop cr ;

: expand-map ( c-addr u -- )
  0 -rot over + swap ?do
  i 1 and if i c@ [char] 0 - map-space
        else dup i c@ [char] 0 - map-file 1+ then
  loop drop ;

: compact1 ( c-addr u -- )
  dup cell+ >r                  \ cad u | u++
  over +                        \ cadr end | u++
  begin cell - r> cell - >r     \ cadr end-- | u--
  dup @ -1 <> until             \ cadr >0 | u-
  dup                           \ cadr >0 >0 | u-
  begin cell - 2 pick over =    \ cadr >0 >0-- cadr=>0-- | u-
  if 2drop 2drop r> 0 exit then \ cadr >0 >0--
  r> cell - >r
  2dup @ swap @ <> until        \ cadr >0 <>
  dup cell+ pad !               \ cadr >0 <> | <>++ to pad
  2dup -                        \ cadr >0 <> len
  rot @ swap 2swap cell+ swap do      \ id len do(<> cadr)
  i @ -1 = if
  cell begin i over + @ -1 = while cell+ repeat \ ch siz siz2
  over >= if \ ch siz
  pad @
  2dup + swap do -1 i ! cell +loop
  i + i do dup i ! cell +loop
  drop unloop r> exit
  then then cell +loop 2drop r> ;

: compact ( c-addr u -- )
  begin 2dup compact1 nip ?dup 0= until drop ;

: checksum ( c-addr u -- n )
  0 -rot 0 do tuck i cells + @ dup -1 =
  if 1+ then i * + swap loop drop ;

disk-map
create full-map expand-map
here full-map - constant full-size

full-map full-size
2dup compact
cell / checksum . cr
bye
