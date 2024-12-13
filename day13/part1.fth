0 value ax 0 value ay
0 value bx 0 value by
0 value px 0 value py
0 value x  0 value y
variable tokens

: get-number 0 s>d 2swap 2 - swap 2 + swap >number 2drop d>s ;
: get-params bl parse get-number bl parse get-number ;

: Button ;
: A:     get-params to ay to ax ; \ 3 tokens
: B:     get-params to by to bx ; \ 1 token
: Prize: get-params to py to px
  -1 to x -1 to y
  100 0 do
  py i ay * - by /mod swap 0= if
  px i ax * - bx 2 pick * - 0= if
  i 3 * + tokens +! leave
  else drop then else drop then loop ;

0 tokens !
include input
tokens ? cr
bye
