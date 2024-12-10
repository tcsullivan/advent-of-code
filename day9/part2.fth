: map-file  ( id n -- ) 0 ?do dup , loop drop ;
: map-space ( n -- )    -1 swap map-file ;

: dump-map   ( c-addr u -- )    over + swap ?do i @ 0<
                                if ." . " else i ? then cell +loop cr ;
: expand-map ( c-addr u -- )    0 -rot over + swap ?do
                                i 1 and if i c@ [char] 0 - map-space
                                else dup i c@ [char] 0 - map-file 1+ then
                                loop drop ;
: checksum ( c-addr u -- n )    0 -rot 0 do tuck i cells + @ dup -1 =
                                if 1+ then i * + swap loop drop ;

: rfind-taken ( c-addr -- c-addr )         begin cell - dup @ -1 <> until ;
: rfind-free  ( base c-addr id -- c-addr ) >r begin cell - 2dup =
                                           over @ r@ <> or until swap r> 2drop ;
: find-taken ( c-addr -- c-addr )          begin cell+ dup @ -1 <> until ;
: free-size ( c-addr -- u )                dup find-taken swap - ;
: take-free ( id c-addr u -- )             over + swap do dup i ! cell +loop drop ;
: free-taken ( c-addr u -- )               -1 -rot take-free ;

: compact1 ( c-addr u -- )
  over + rfind-taken              \ cadr taken
  2dup dup @ rfind-free           \ cadr taken free
  rot 2dup = if 2drop drop 0 exit then -rot
  dup 3 pick - cell+ >r
  dup >r cell+ -rot r>            \ cadr >0 <>
  2dup -                          \ cadr >0 <> len
  rot @ swap 2swap cell+ swap do  \ id len do(<> cadr)
  i @ -1 = if
  i free-size over >= if
  rot over free-taken
  i swap take-free
  unloop r> exit
  then then cell +loop 2drop drop r> ;

: compact ( c-addr u -- ) begin 2dup compact1 nip ?dup 0= until drop ;

s" input" slurp-file 1-
create full-map expand-map
here full-map - constant full-size

full-map full-size
2dup compact cell / checksum . cr
bye
