0 value A 0 value B
0 value C 0 value D
0 value E 0 value F
0 value poffset

: read-num >r 2 + r> 2 - 0 s>d 2swap >number 2drop d>s ;
: read-xy  bl parse read-num bl parse read-num ;

: Button ;
: A:     read-xy to D to A ;
: B:     read-xy to E to B ;
: Prize: read-xy poffset + to F poffset + to C
  C E * B F * - B D * A E * - /mod swap if drop exit then negate 3 *
  C D * A F * - B D * A E * - /mod swap if 2drop else + + then ;

0 include input ." Part 1: " . cr
10000000000000 to poffset
0 include input ." Part 2: " . cr
bye
