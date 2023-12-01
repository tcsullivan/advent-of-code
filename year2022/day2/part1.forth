: next-rpc ( fd -- score-or-false-if-eof )
    pad 4 rot read-line throw                   ( read next line from file    )
    swap 3 = and if                             ( if read complete round      )
        pad 2 + c@ dup 87 -                     ( score for our hand          )
        swap pad c@ -                           ( difference between hands    )
        dup 23 = if drop 3 + else               ( 3pts for tie e.g. 'X' - 'A' )
            dup 21 = swap 24 = or if 6 + then   ( 6pts for win                )
        then
    else false then ;                           ( false if end-of-file        )

: all-rpcs ( fd -- total-score )
    0 begin                                     ( start with zero score       )
        over next-rpc                           ( read next hand              )
        dup if + true then                      ( add to score if not EOF     )
    0= until nip ;

s" input" r/o open-file throw all-rpcs . cr     ( play all rounds in input    )
bye

