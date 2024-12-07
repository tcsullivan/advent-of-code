include ../common.fth

0 value result
2 value ebase
create nums 100 cells allot
0 value nums-count

create part1 0 ,
create part2 0 ,

: advance     ( c-addr u -- c-addr u )   1- swap 1+ swap ;
: read-number ( c-addr u -- n c-addr u ) 0 s>d 2swap >number rot drop ;
: pow         ( x n -- x^n )             1 swap 0 ?do over * loop nip ;
: concat      ( n n -- nn )              dup >r begin dup while
                                         swap 10 * swap 10 / repeat drop r> + ;
: get-bit     ( n n -- n )               1- 0 ?do ebase / loop ebase mod ;

: capture-equ   read-number rot to result advance
                begin dup 0<> while
                advance read-number rot nums nums-count cells + !
                nums-count 1+ to nums-count repeat 2drop ;

: figure-equ    ebase nums-count 1- pow 0 do
                nums @ \ result
                nums-count 1 do
                nums i cells + @
                j i get-bit case
                0 of + endof
                1 of * endof
                2 of concat endof
                endcase loop
                result = if unloop true exit then
                loop false ;

: solve         0 to nums-count capture-equ
                2 to ebase figure-equ if result dup part1 +! part2 +! else
                3 to ebase figure-equ if result part2 +! then then ;

open-input ' solve each-line
." Part 1: " part1 ? cr
." Part 2: " part2 ? cr
bye

