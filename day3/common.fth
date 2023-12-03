12 constant schwidth
12 constant schheight

: line:
  bl parse here over allot swap move ;

create schematic
line: ............
line: .467..114...
line: ....*.......
line: ...35..633..
line: .......#....
line: .617*.......
line: ......+.58..
line: ...592......
line: .......755..
line: ....$.*.....
line: ..664.598...
line: ............

: sch@ ( y x -- n )
  schematic + swap schwidth * + c@ ;

: digit? ( n -- b )
  dup [char] 0 >= swap [char] 9 <= and ;

: get-number ( y x -- n )
  begin
  2dup sch@ digit? while
  1- repeat
  0 >r 1+ begin
  2dup sch@ dup digit? while
  [char] 0 - r> 10 * + >r 1+ repeat
  drop 2drop r> ;

: find-numbers ( y x -- )
  0 pad ! pad -rot
  dup 2 + swap 1- rot
  dup 2 + swap 1-
  do 2dup do
  j i sch@ digit? if
  rot j i get-number \ . . p n
  over @ over <> if swap cell+ tuck ! else drop then -rot
  then
  loop loop 2drop ;
