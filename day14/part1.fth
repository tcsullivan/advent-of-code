include ../common.fth

101 constant width
103 constant height

create counts 0 , 0 , 0 , 0 ,

: advance ( c-addr u n -- c-addr u )
  tuck - >r + r> ;
: get-number ( c-addr u -- n c-addr u )
  over c@ [char] - = dup >r if 1 advance then
  0 s>d 2swap >number 2swap d>s
  r> if negate then -rot ;
: move-robot ( px py vx vy n -- py px )
  tuck * -rot * \ px py dy dx
  -rot + -rot + \ py px
  width mod swap height mod ;
: count-robot ( py px -- )
  swap 2dup width 2/ = swap height 2/ = or if 2drop exit then
  width 2/ < swap height 2/ <
  counts swap if 2 cells + then swap if cell+ then
  1 swap +! ;
: add-robot ( c-addr u -- )
  2 advance get-number
  1 advance get-number
  3 advance get-number
  1 advance get-number 2drop
  100 move-robot count-robot ;
: safety-factor ( -- n )
  1 4 0 do counts i cells + @ * loop ;

open-input ' add-robot each-line
safety-factor . cr
bye
