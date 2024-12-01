\ Advent of Code 2023, Day 6 Parts 1 & 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - For part 2, manually concatenate the numbers.

variable times
variable distances

: get-number ( -- n b )
  \ Parses the next number on the current line, returning that number and a
  \ boolean to indicate if the parse was successful.
  0 s>d bl word count
  dup 0> >r >number 2drop drop r> ;

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

: solve ( time dist -- n )
  \ Solves for the number of winning races using the quadratic formula given
  \ the time and distance coeffecients.
  \ The formula is: my-distance = (time*x - x^2)-distance
  \ Finding the difference between the (floored) roots determines the number of
  \ winning races. We subtract 1/1000 from the positive root to handle cases
  \ where both roots are whole numbers.
  over dup * 4 rot negate * +            \ stack: time, b^2-4ac
  s>f fsqrt s>f                          \ fp stack: sqrt(b^2-4ac), time
  fswap fover fover                      \ fp stack: time, sqrt, time, sqrt
  f+ f2/ 1000 s>f 1/f f- floor frot frot \ fp stack: +root, time, sqrt
  f- f2/ floor f>s f>s swap - ;          \ stack: (+root - -root)

: try-all-races ( -- n )
  \ Counts winning races for each pair in `times` and `distances`, multiplying
  \ them together for a final result.
  1 0 time@ 1+ 1 do
  i time@ i distance@ solve * loop ;

include input

utime
try-all-races . cr
utime 2swap d- d. cr
bye

