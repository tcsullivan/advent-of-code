create outcomes 3 , 4 , 8 , 1 , 5 , 9 , 2 , 6 , 7 , ( AX-Z, BX-Z, CX-Z )

: next-rpc ( fd -- outcome )
    pad 4 rot read-line throw                   ( read next line from file     )
    swap 3 = and if                             ( if read complete round       )
        pad c@ 65 - 3 *                         ( calculate ABC outcomes index )
        pad 2 + c@ 88 - +                       ( add XYZ offset               )
        cells outcomes + @                      ( lookup score for the round   )
    else false then ;                           ( false if end-of-file         )

: all-rpcs ( fd -- total-score )
    0 begin                                     ( start with zero score        )
        over next-rpc                           ( read next hand               )
        dup if + true then                      ( add to score if not EOF      )
    0= until nip ;

s" input" r/o open-file throw all-rpcs . cr     ( play all rounds in input     )
bye

