REM Advent of Code 2022: Day 9, part 1
REM Written in Applesoft BASIC

REM HS is a "set" of unique tail coordinates.

 10  DIM HS(7000)
 20 HX = 0:HY = 0
 30 TX = 0:TY = 0

REM Read a line of input.

 100 S$ = ""
 110  GET C$
 120  IF  ASC (C$) < 32 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110

REM If empty, we're done. Otherwise, extract direction and count.

 200  IF  LEN (S$) = 0 THEN  GOTO 1000
 210 D$ =  LEFT$ (S$,1)
 220 S =  VAL ( MID$ (S$,3, LEN (S$) - 2))
 230  PRINT ">>",D$;" ";S

REM For each step...
REM Handle head movement, then GOTO 400 to handle the tail.

 300  FOR I = 1 TO S
 310  IF D$ = "U" THEN HY = HY + 1: GOTO 400
 320  IF D$ = "D" THEN HY = HY - 1: GOTO 400
 330  IF D$ = "R" THEN HX = HX + 1: GOTO 400
 340  IF D$ = "L" THEN HX = HX - 1: GOTO 400
 350  PRINT "ERROR: ";D$
 360  END 

REM If no movement is necessary, GOTO 460. Otherwise, GOSUB 500 and/or 550
REM to move the tail as needed.

 400 DX = HX - TX:DY = HY - TY
 410  IF  ABS (DX) <  = 1 AND  ABS (DY) <  = 1 GOTO 460
 420  IF HX <  > TX THEN  GOSUB 500
 430  IF HY <  > TY THEN  GOSUB 550

REM Create a hash of the tail coordinates, then try placing it in the "set".

 440 HH = TX * 1000 + TY
 450  GOSUB 600

REM Handle next step for the current direction, or GOTO 100 for next input.

 460  NEXT I
 470  GOTO 100

REM Move tail one place closer to head in the X direction.

 500 Z =  - 1
 510  IF HX > TX THEN Z = 1
 520 TX = TX + Z
 530  RETURN 

REM Move tail one place closer to head in the Y direction.

 550 Z =  - 1
 560  IF HY > TY THEN Z = 1
 570 TY = TY + Z
 580  RETURN 

REM "Set" insertion:
REM If hash is already in the set, then exit.
REM Otherwise, if an empty slot is found, add the hash to the set.

 600  FOR J = 0 TO 6999
 610  IF HS(J) = HH THEN J = 6999: GOTO 630
 620  IF HS(J) = 0 THEN HS(J) = HH:J = 9999
 630  NEXT J
 640  RETURN 

REM All input has been read. Count up entries in the "set" and display.

 1000 CO = 0
 1010  FOR I = 0 TO 9999
 1020 CO = CO + 1
 1030  IF HS(I) = 0 THEN I = 9999
 1040  NEXT I
 1050  PRINT "TOTAL: ";CO
 1060  END 

