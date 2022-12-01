REM Advent of Code 2022: Day 1, part 1
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900
 20 MOST = 0:CURR = 0
 30  PRINT  CHR$ (4),"OPEN INPUT"
 40  PRINT  CHR$ (4),"READ INPUT"
 100 S$ = ""
 110  GET C$
 120  IF  ASC (C$) = 13 GOTO 200
 130 S$ = S$ + C$
 135  GET D$
 140  GOTO 110
 200 V =  VAL (S$)
 205  GET D$
 210  IF V = 0 GOTO 300
 220 CURR = CURR + V
 230  GOTO 100
 300  IF MOST < CURR THEN MOST = CURR
 310 CURR = 0
 320  PRINT MOST
 330  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  END 
