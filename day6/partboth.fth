\ Advent of Code 2023, Day 6 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ FORTH-79 compatible!
\
\ Input file changes:
\ - For part 2, manually concatenate the numbers.

variable times
variable distances

: 0<>   0= 0= ;
: s>d   0 ;
: 2drop drop drop ;
: -rot  rot rot ;
: tuck  dup -rot ;

: read-number ( n c-addr u -- n )
  \ Reads digits from (c-addr u), accumulating them into `n`.
  dup 0= if 2drop exit then
  0 do
  dup c@ 48 -
  rot base @ * + swap char+ loop drop ;

: get-number ( -- n b )
  \ Parses the next number on the current line, returning that number and a
  \ boolean to indicate if the parse was successful.
  0 bl word count
  dup 0<> >r read-number r> ;

: store-numbers ( c-addr -- )
  \ Reads all remaining numbers on the current line and stores them at here,
  \ writing the base address to c-addr. The first cell contains the counf of
  \ numbers read.
  here dup rot ! 0 ,
  begin get-number while , repeat
  drop here over - 1 cells / 1- swap ! ;

: time@ ( n -- n )
  \ Fetches the n-th time from the times data.
  cells times @ + @ ;

: distance@ ( n -- n )
  \ Fetches the n-th distance from the distances data.
  cells distances @ + @ ;

: Time:     times     store-numbers ;
: Distance: distances store-numbers ;

: calc-race ( total-time time -- dist )
  \ Calculates the distance traveled in a total-time-long race where speed
  \ is built up for time milliseconds.
  tuck - * ;

: count-winning-races ( time dist -- n )
  \ Counts the number of possible winning races for a `dist`-long race with
  \ best time `time`.
  0 -rot over 1 do
  over i calc-race
  over > negate >r rot r> + -rot
  loop 2drop ;

: try-all-races ( -- n )
  \ Counts winning races for each pair in `times` and `distances`, multiplying
  \ them together for a final result.
  1 0 time@ 1+ 1 do
  i time@ i distance@ count-winning-races * loop ;

include input

try-all-races . cr
bye

