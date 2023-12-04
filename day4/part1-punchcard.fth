0 : C create 0 , ; C W C M : D depth 1- ; : R here W @ over + swap ; : | W @ 0=
if D W ! then R do i c! loop ; : T 0 M @ 0= if D 1- M ! then M @ 0 ?do swap pad
! 0 R do i c@ pad @ = + loop - loop 1 swap lshift 2/ + ; : Card T C ;
include input T . bye
