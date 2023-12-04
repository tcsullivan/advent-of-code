create W 0 , create M 0 , : D depth 1- ; : R here W @ over + swap ; : | W @ 0=
if D W ! then R do i c! loop ; : C pad ! 0 R do i c@ pad @ = or loop ; : T 0 M
@ 0= if D 1- M ! then M @ 0 do swap C - loop 1 swap 1- lshift + ; : Card D if
T then 58 parse 2drop ; 0
include input T . cr bye
