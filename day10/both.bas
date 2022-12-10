REM Advent of Code 2022: Day 9, part 1
REM Written in Applesoft BASIC

 10  GR 
 20 CX = 0
 22 CY = 14
 24 AD = 0
 26 X = 1
 28 CC = 1
 38 ST = 0
 40 D = 0
 42 SC = 1
 44 SM = 20
 50  PRINT  CHR$ (4),"OPEN INPUT"
 60  PRINT  CHR$ (4),"READ INPUT"
 70  ONERR  GOTO 1000

REM Read the next input line into S$.

 100 S$ = ""
 110  GET C$
 120  IF C$ < " " GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110

REM Parse into instruction letter ("a" or "n") and addx parameter N.

 200 L =  LEN (S$)
 205  IF L = 0 GOTO 1000
 208  PRINT "> ";S$
 210 II$ =  LEFT$ (S$,1)
 220  IF L < 6 THEN N = 0
 230  IF L > 5 THEN N =  VAL ( RIGHT$ (S$,L - 5))
 240 D = 0
 250 AD = 0

REM Update the "CRT" based on X-position and X-register.

 300  COLOR= 0
 310  IF  ABS (X - CX) < 2 THEN  COLOR= CX / 5 + 1
 320  PLOT CX,CY
 330 CX = CX + 1
 340  IF CX > 39 THEN CX = 0:CY = CY + 1

REM Run the next cycle. AD != 0 on 2nd cycle of addx.

 400 CC = CC + 1
 410  IF AD = 0 GOTO 450
 420 X = X + AD
 430 AD = 0
 440 D = 1
 445  GOTO 500
 450  IF II$ = "a" THEN AD = N
 460  IF II$ = "n" THEN D = 1

REM Update strength counter, and strength total if necessary.
REM Otherwise, GOTO 100 for next instruction or 300 for next addx cycle.

 500 SC = SC + 1
 510  IF SC < SM GOTO 530
 515 SM = SM + 40
 520 ST = ST + CC * X
 530  IF D = 1 GOTO 100
 550  GOTO 300

REM End of input: print strength and exit.

 1000  PRINT "STRENGTH: ";ST
 1010  PRINT  CHR$ (4),"CLOSE"
 1020  END 

