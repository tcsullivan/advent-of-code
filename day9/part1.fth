: disk-map s" input" slurp-file 1- ;

: map-file  ( id n -- ) 0 ?do dup , loop drop ;
: map-space ( n -- )    0 ?do  -1 , loop ;

: pad-map ( c-addr u -- c-addr u )
  here dup >r swap dup >r move
  2r> dup allot dup 1 and if [char] 0 c, 1+ then ;

: expand-map ( c-addr u -- )
  0 -rot \ id
  over + swap ?do
  dup i c@ [char] 0 - map-file
  i 1+  c@ [char] 0 - map-space
  1+ 2 +loop drop ;

: compact-map ( c-addr u -- c-addr u )
  over >r cells over + >r
  begin dup r@ < while
  dup @ -1 = if
  r> begin cell - dup @ -1 <> until
  2dup @ swap ! >r
  then cell+ repeat
  r> drop r> tuck - cell / ;

: checksum ( c-addr u -- n )
  0 -rot 0 do tuck i cells + @ i * + swap loop drop ;

disk-map pad-map
create full-map expand-map
here full-map - cell / constant full-size

full-map full-size
compact-map
checksum .
cr bye
