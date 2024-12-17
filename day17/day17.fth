0 value A
0 value B
0 value C
0 value IP

create orig 100 allot
variable origu
create outp 100 allot
variable oute

defer outemit

: combo case
  0 of 0 endof
  1 of 1 endof
  2 of 2 endof
  3 of 3 endof
  4 of A endof
  5 of B endof
  6 of C endof
  endcase ;
: adv A 1 rot combo lshift / to A ;
: bxl B xor                  to B ;
: bst combo 7 and            to B ;
: jnz A if 4 - to IP else drop then ;
: bxc drop B C xor           to B ;
: out combo 7 and outemit ;
: bdv A 1 rot combo lshift / to B ;
: cdv A 1 rot combo lshift / to C ;

create optable
' adv , ' bxl , ' bst , ' jnz ,
' bxc , ' out , ' bdv , ' cdv ,

: c>s c@ [char] 0 - ;
: exec  orig origu @ begin IP over < oute @ 0>= and while
        over IP + dup
        2 + c>s swap c>s cells optable + @
        execute IP 4 + to IP repeat 2drop ;
: reset 0 to B 0 to C 0 to IP orig oute ! ;
: runA  0 begin dup 131071 and 0= if 13 emit dup . then dup to A reset exec
        origu @ oute @ orig - - 1 > while 1+ repeat ;

: Register ;
: A:       0 s>d bl parse >number 2drop d>s to A ;
: B:       0 s>d bl parse >number 2drop d>s to B ;
: C:       0 s>d bl parse >number 2drop d>s to C ;
: Program: bl parse dup origu ! orig swap move ;

include input

:noname [char] 0 + oute @ tuck c!
        [char] , swap 1+ tuck c!
        1+ oute ! ;
is outemit
." Part 1: " outp oute ! exec outp oute @ over - type cr

:noname [char] 0 + oute @ c@ = 
        if 2 oute +! else -1 oute ! then ;
is outemit
." Part 2: " runA . cr
bye
