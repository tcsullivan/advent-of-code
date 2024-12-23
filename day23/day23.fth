\ Run with 16MB dictionary

include ../common.fth

36 dup * constant entry
create lan    entry dup * cells allot
create t-list entry       cells allot
create tri    3           cells allot

: lwhile postpone begin postpone dup postpone @ postpone while ; immediate
: leach  postpone begin postpone dup postpone @ postpone ?dup postpone while ; immediate
: lnext  postpone cell+ postpone repeat ; immediate

: lan-row entry cells * lan + ;

: add-connection ( from to -- )
  swap lan-row lwhile lnext ! ;

: add-pair ( n n -- )
  2dup add-connection swap add-connection ;

: parse-pair ( c-addr u -- )
  0 s>d 2swap >number 2swap d>s >r
  0 s>d 2swap 1- swap 1+ swap >number 2drop d>s r>
  add-pair ;

36 base !

: 2sort 2dup > if swap then ;
: sorted-tri ( -- n )
  tri 2@ tri 2 cells + @
  2sort >r 2sort r> 2sort
  swap 100 * + swap 10000 * + ;

: add-tri ( -- )
  sorted-tri t-list lwhile 2dup @ = if 2drop exit then lnext ! ;

: count-tri ( -- n )
  t-list dup lwhile lnext swap - cell / ;

: collect-tri ( -- )
  U0 T0 do i
  dup tri           ! lan-row leach
  dup tri cell+     ! lan-row leach dup i <> if
  dup tri 2 cells + ! lan-row leach
    i = if add-tri then lnext
  then drop lnext drop lnext drop
  loop ;

open-input ' parse-pair each-line
collect-tri
decimal count-tri . cr
bye
