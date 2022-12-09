REM Advent of Code 2022: Day 9, part 1
REM Written in Applesoft BASIC

REM Same as part1, but track positions in SX and SY arrays.
REM At 405, we reuse HX/HY/TX/TY to minimize changes from part1.

 10  DIM HS(7000)
 20  DIM SX(10)
 30  DIM SY(10)
 40  FOR I = 0 TO 9:SX(I) = 0: NEXT I
 50  FOR I = 0 TO 9:SY(I) = 0: NEXT I
 100 S$ = ""
 110  GET C$
 120  IF  ASC (C$) < 32 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110
 200  IF  LEN (S$) = 0 THEN  GOTO 1000
 210 D$ =  LEFT$ (S$,1)
 220 S =  VAL ( MID$ (S$,3, LEN (S$) - 2))
 230  PRINT ">>",D$;" ";S
 300  FOR I = 1 TO S
 310  IF D$ = "U" THEN SY(0) = SY(0) + 1: GOTO 400
 320  IF D$ = "D" THEN SY(0) = SY(0) - 1: GOTO 400
 330  IF D$ = "R" THEN SX(0) = SX(0) + 1: GOTO 400
 340  IF D$ = "L" THEN SX(0) = SX(0) - 1: GOTO 400
 350  PRINT "ERROR: ";D$
 360  END 
 400  FOR K = 1 TO 9
 405 HX = SX(K - 1):HY = SY(K - 1)
 410 TX = SX(K):TY = SY(K)
 415 DX = HX - TX:DY = HY - TY
 420  IF  ABS (DX) <  = 1 AND  ABS (DY) <  = 1 GOTO 460
 430  IF HX <  > TX THEN  GOSUB 500
 435  IF HY <  > TY THEN  GOSUB 550
 440 SX(K) = TX:SY(K) = TY
 445  NEXT K
 450 HH = TX * 1000 + TY
 455  GOSUB 600
 460  NEXT I
 470  GOTO 100
 500 Z =  - 1
 510  IF HX > TX THEN Z = 1
 520 TX = TX + Z
 530  RETURN 
 550 Z =  - 1
 560  IF HY > TY THEN Z = 1
 570 TY = TY + Z
 580  RETURN 
 600  FOR J = 0 TO 6999
 610  IF HS(J) = HH THEN J = 6999: GOTO 630
 620  IF HS(J) = 0 THEN HS(J) = HH:J = 9999
 630  NEXT J
 640  RETURN 
 1000 CO = 0
 1010  FOR I = 0 TO 9999
 1020 CO = CO + 1
 1030  IF HS(I) = 0 THEN I = 9999
 1040  NEXT I
 1050  PRINT "TOTAL: ";CO
 1060  END 

