0 value A
0 value B
0 value C
0 value IP

create orig 100 allot
variable origu
create outp 100 allot
variable oute

: outemit [char] 0 + oute @ tuck c!
          [char] , swap 1+ tuck c!
          1+ oute ! ;

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
: bst combo 8 mod            to B ;
: jnz A if 4 - to IP else drop then ;
: bxc drop B C xor           to B ;
: out combo 8 mod outemit ;
: bdv A 1 rot combo lshift / to B ;
: cdv A 1 rot combo lshift / to C ;

create optable
' adv , ' bxl , ' bst , ' jnz ,
' bxc , ' out , ' bdv , ' cdv ,

: c>s c@ [char] 0 - ;
: reset 0 to B 0 to C 0 to IP
        outp oute ! ;
: exec  reset orig origu @ begin IP over < while
        over IP + dup
        2 + c>s swap c>s cells optable + @
        execute IP 4 + to IP repeat 2drop ;
: test  origu @ oute @ <> if false exit then
        origu @ 0 do
        orig i + c@ outp i + c@ <> if
        unloop false exit then loop true ;
: runA  100000000 10000000 do
        i to A exec test if i . leave then loop ;

: Register ;
: A:       0 s>d bl parse >number 2drop d>s to A ;
: B:       0 s>d bl parse >number 2drop d>s to B ;
: C:       0 s>d bl parse >number 2drop d>s to C ;
: Program: bl parse dup origu ! orig swap move ;

include input
." Part 1: " exec outp oute @ over - type cr
." Part 2: " runA cr
bye
