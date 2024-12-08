include ../common.fth

    0 value result
    0 value nums-count
false value 3flag

create nums 20 cells allot
create part1 0 ,
create part2 0 ,

create pow3table 1 , 3 , 9 , 27 , 81 , 243 , 729 , 2187 , 6561 , 19683 , 59049 ,
                 177147 , 531441 , 1594323 , 4782969 , 14348907 , 43046721 ,
                 129140163 , 387420489 , 1162261467 , 3486784401 ,
: pow3          ( n -- 3^n )                cells pow3table + @ ;
: advance       ( c-addr u -- c-addr u )    1- swap 1+ swap ;
: read-number   ( c-addr u -- c-addr u n )  0 s>d 2swap >number 2swap drop ;
: concat        ( n n -- nn )               tuck begin swap 10 * swap 10 /
                                            ?dup 0= until + ;

: capture-equ   nums >r read-number to result advance
                begin advance read-number r> tuck ! cell+ >r ?dup 0= until
                drop r> nums - cell / to nums-count ;

: figure-equ    nums-count 1- pow3 0 do false to 3flag
                nums dup @ i rot cell+ nums-count 1- cell-do
                3 /mod -rot i @ swap case
                0 of + endof
                1 of * endof
                >r concat true to 3flag r>
                endcase swap cell-loop
                drop result = ?dup if unloop exit then
                loop false ;

: solve         0 to nums-count capture-equ figure-equ if
                result 3flag if part2 else part1 then +! then ;

open-input ' solve each-line
part1 @ part2 +!
." Part 1: " part1 ? cr
." Part 2: " part2 ? cr
bye

