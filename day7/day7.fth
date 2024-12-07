include ../common.fth

0 value result
2 value ebase
create nums 50 cells allot
0 value nums-count

create part1 0 ,
create part2 0 ,

create pow3table 1 , 3 , 9 , 27 , 81 , 243 , 729 , 2187 , 6561 , 19683 , 59049 ,
                 177147 , 531441 , 1594323 , 4782969 , 14348907 , 43046721 ,
                 129140163 , 387420489 , 1162261467 , 3486784401 ,
: fast-pow    ( x n -- x^n )             swap 2 = if 1 swap lshift else cells pow3table + @ then ;
: advance     ( c-addr u -- c-addr u )   1- swap 1+ swap ;
: read-number ( c-addr u -- n c-addr u ) 0 s>d 2swap >number rot drop ;
: concat      ( n n -- nn )              dup >r begin swap 10 * swap 10 / dup 0= until drop r> + ;

: capture-equ   nums >r read-number rot to result advance
                begin advance read-number rot r> tuck ! cell+ >r dup 0= until
                2drop r> nums - cell / to nums-count ;

: figure-equ    ebase nums-count 1- fast-pow 0 do
                nums dup @ i rot cell+ nums-count 1- cell-do
                ebase /mod -rot i @ swap case
                0 of + endof
                1 of * endof
                2 of concat endof
                endcase swap cell-loop
                drop result = if unloop true exit then
                loop false ;

: solve         0 to nums-count capture-equ
                2 to ebase figure-equ if result part1 +! else
                3 to ebase figure-equ if result part2 +! then then ;

open-input ' solve each-line
part1 @ part2 +!
." Part 1: " part1 ? cr
." Part 2: " part2 ? cr
bye

