REM Advent of Code 2022: Day 1, part 2
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900
 20  DIM CALS(5):CURR = 0
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
 300  FOR I = 0 TO 5
 310  IF CURR = CALS(I) GOTO 360
 320  IF CURR < CALS(I) THEN  NEXT I
 330  FOR J = 3 TO I STEP  - 1:CALS(J + 1) = CALS(J): NEXT 
 340 CALS(I) = CURR
 350  PRINT CALS(0),CALS(1),CALS(2)
 360 CURR = 0
 370  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  PRINT CALS(0) + CALS(1) + CALS(2)
 920  END 

