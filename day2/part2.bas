REM Advent of Code 2022: Day 2, part 2
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900
 20  PRINT  CHR$ (4),"OPEN INPUT"
 30  PRINT  CHR$ (4),"READ INPUT"
 60  DIM RPC$(3):RPC$(0) = "ROCK":RPC$(1) = "PAPER":RPC$(2) = "SCISSORS"
 70 SC = 0
 80  DIM OC(9):OC(0) = 3:OC(1) = 4:OC(2) = 8:OC(3) = 1:OC(4) = 5:OC(5) = 9:OC(6) = 2:OC(7) = 6:OC(8) = 7
 90  DIM MYC$(3):MYC$(0) = "LOSE":MYC$(1) = "DRAW":MYC$(2) = "WIN"
 100  GET A$: GET Z$
 110  GET Z$: GET Z$
 120  GET B$: GET Z$
 130  GET Z$: GET Z$
 140 AV =  ASC (A$) - 65
 150 BV =  ASC (B$) - 88
 160 OI = AV * 3 + BV
 170 SC = SC + OC(OI)
 180  PRINT "OPPONENT PLAYS ";RPC$(AV);",","I ";MYC$(BV);".","SCORE = ";SC
 190  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  END 


