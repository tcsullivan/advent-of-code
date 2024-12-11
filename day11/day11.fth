: stack>buffer ( ... -- c-addr u )
  here depth 1- cells 2dup 2>r tuck + >r allot
  r> depth 1- 0 do cell - tuck ! loop drop 2r> ;

: dump-stones over + swap do i ? cell +loop cr ;
: digits 0 begin 1+ swap 10 / tuck 0= until nip ;
: even?  1 and 0= ;
: split ( n digits -- n1 n2 )
  2/ 1 swap 0 ?do 10 * loop /mod ;
: blink ( c-addr u -- c-addr u )
  over + 2dup swap do
  i @
  dup 0= if drop 1 i ! else
  dup digits dup even? if split i ! over ! cell+ else
  drop 2024 * i !
  then then cell +loop over - ;
: blink-n ( c-addr u n -- c-addr u )
  0 do i . blink loop ;

s" input" slurp-file evaluate
stack>buffer 2dup dump-stones
75 blink-n
nip cell / . cr
bye

