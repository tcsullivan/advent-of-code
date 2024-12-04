0 value W 1 value H 0 value M : C tuck compare 0= or ; include ../common.fth
: S swap ; : O over ; : x? 0 O s" XMAS" C S s" SAMX" C ; : m? 0 O s" AMSMS" C O
s" ASSMM" C O s" ASMSM" C S s" AMMSS" C ; : a allot here ; : +x -4 a x? + ; : +m
-5 a m? + ; : N a 2drop H 1+ to H ; : tm S W * + M + ; : c c@ c, ; : wh >r tm r>
W + 4 0 do O c tuck + S loop 2drop ; : xh tm dup c dup 1- dup W - c W + c 1+ dup
W - c W + c ; : P 0 H 0 do W 3 - 0 do j i tm x? + loop loop H 3 - 0 do W 0 do j 
i 0 wh +x loop loop H 3 - 0 do W 3 - 0 do j i 1 wh +x loop loop H 3 - 0 do W 3
do j i -1 wh +x loop loop ; : Q 0 H 1-  1 do W 1-  1 do j i xh +m loop loop ;
open-input dup input-line drop dup to W allot to M ' N each-line P . Q . cr bye
