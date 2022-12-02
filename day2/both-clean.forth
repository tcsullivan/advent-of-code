1 constant rock
2 constant paper
3 constant scissors

: is-win ( them us -- yes ) - dup <0 swap 2 = or ;

: get-score ( them us -- score )
  2dup is-win if 6 + else
  2dup = if 3 +
  then then nip ;

: get-loser ( them -- us ) 2 - 3 mod 1+ ;
: get-winner ( them -- us ) 3 mod 1+ ;

: A rock ;
: B paper ;
: C scissors ;
: X rock get-score + ;
: Y paper get-score + ;
: Z scissors get-score + ;

0
include input
. cr

: X dup get-loser get-score + ;
: Y dup get-score + ;
: Z dup get-winner get-score + ;

0
include input
. cr

bye

