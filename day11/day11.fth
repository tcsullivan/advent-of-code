10000 cells constant max-dict
create dict max-dict allot
create dict2 max-dict allot
dict  value from-dict
dict2 value to-dict

: each-dict postpone to-dict postpone begin ; immediate
: next-dict postpone cell+ postpone cell+ postpone repeat ; immediate

: dict-add   ( n id -- ) each-dict 2dup 2@ rot <> and
                         while next-dict tuck ! cell+ +! ;
: dict-total ( -- n )    0 each-dict dup cell+ @ ?dup
                         while rot + swap next-dict drop ;
: dict-swap  ( -- )      to-dict from-dict dup max-dict 0 fill
                         to to-dict to from-dict ;
: stack>dict ( ... -- )  depth 0 do 1 swap dict-add loop ;

: digits 0 begin 1+ swap 10 / tuck 0= until nip ;
: even?  1 and 0= ;
: split ( n digs -- n1 n2 ) 2/ 1 swap 0 ?do 10 * loop /mod ;

: blink ( -- )
  from-dict begin dup 2@ over while
  ?dup if \ dict count id
    dup digits dup even? if
    split >r over r> dict-add dict-add
    else drop 2024 * dict-add then
  else 1 dict-add then
  next-dict 2drop drop ;
: blink-n ( n -- ) 0 do dict-swap blink loop ;

s" input" slurp-file evaluate stack>dict
25 blink-n ." Part 1: " dict-total . cr
50 blink-n ." Part 2: " dict-total . cr
bye
