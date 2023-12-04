0 create W 0 , create M 0 , : D depth 1- ; : R here W @ over + swap ; : | W @ 0=
if D W ! then R do i c! loop ; : T 0 M @ 0= if D 1- M ! then M @ 0 ?do swap pad
! 0 R do i c@ pad @ = or loop - loop 1 swap 1- lshift + ; : Card T create ;
include input T 1 lshift 2/ . cr bye
