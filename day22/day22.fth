: mix    ( n n -- n ) xor ;
: prune  ( n -- n )   16777215 and ;
: rand   ( n -- n )   dup  6 lshift mix prune
                      dup  5 rshift mix prune
                      dup 11 lshift mix prune ;
: price  ( n -- n )   10 mod ;
: rand-n ( n n -- n ) 0 ?do rand loop ;
: stack> ( ... -- )   depth 0 do , loop ;

include input create market stack>
here constant market-end

: part1 ( -- n )
  0 market-end market do i @ 2000 rand-n + cell +loop ;

part1 . cr
bye

