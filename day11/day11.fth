10000 cells constant max-dict
create dict max-dict allot
create dict2 max-dict allot
dict  value from-dict
dict2 value to-dict

: count@  cell+ @ ;
: dict+   [ 2 cells ] literal + ;
: dict!   tuck ! cell+ +! ;

: each-dict postpone to-dict postpone begin postpone dup
            postpone count@ postpone while ; immediate
: loop-dict postpone dict+ postpone repeat postpone drop ; immediate

: dict-add   ( n id -- ) each-dict 2dup @ = if dict! exit then dict+ repeat dict! ;
: dict-total ( -- n )    0 each-dict dup count@ rot + swap loop-dict ;
: dict-swap              to-dict from-dict to to-dict to from-dict
                         to-dict max-dict 0 fill ;
: stack>dict             depth 0 do 1 swap dict-add loop ;

: digits 0 begin 1+ swap 10 / tuck 0= until nip ;
: even?  1 and 0= ;
: split ( n digs -- n1 n2 ) 2/ 1 swap 0 ?do 10 * loop /mod ;

: blink ( -- )
  from-dict begin dup count@ while
  dup @ over count@ swap \ dict count id
  ?dup if
    dup digits dup even? if
    split rot tuck swap dict-add swap dict-add
    else drop 2024 * dict-add then
  else 1 dict-add then
  loop-dict ;
: blink-n ( n -- ) 0 do dict-swap blink loop ;

s" input" slurp-file evaluate stack>dict
25 blink-n ." Part 1: " dict-total . cr
50 blink-n ." Part 2: " dict-total . cr
bye

