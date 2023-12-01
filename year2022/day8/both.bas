REM Advent of Code 2022: Day 8, part 1 and 2
REM Written in Applesoft BASIC

REM Store the map as an array of strings.

 10 SZ = 40
 20  DIM MP$(SZ)
 30 VI = 0
 40 SC = 0:SX = 2:SY = 1

 60  GR 
 70  PRINT "LEARNING ABOUT TREES";
 80  SPEED= 60: PRINT "...";: SPEED= 255

 100  PRINT  CHR$ (4),"open input"
 110  PRINT  CHR$ (4),"read input"

REM Read all lines of the input file, adding them into the MP$ array.

 120 I = 0
 140 S$ = ""
 150  GET C$
 160  IF  ASC (C$) > 31 THEN S$ = S$ + C$: GOTO 150
 170 MP$(I) = S$
 180 I = I + 1
 185  IF I = SZ GOTO 200
 190  GOTO 140

REM Close the file once we've finished reading.
REM Initialize the visible count to include border trees.

 200  PRINT  CHR$ (4),"close"
 210 VI = 2 *  LEN (MP$(0)) - 4 + 2 * SZ
 220  HTAB 1
 230  PRINT "PLOTTING...            "

REM Main loop: Iterate through all possibly-hidden and/or scenic trees.
REM GOSUB 3000 is a (test) graphical routine to draw the tree.
REM GOSUB 1000 checks hidden-ness of the tree, possibly incrementing the
REM visibility count. If not visible, the tree is colored dark green.
REM GOSUB 2000 calculates the scenic score for the tree. If a new more
REM scenic spot is found, it is colored pink.

 300  FOR Y = 1 TO SZ - 2
 310 S$ = MP$(Y)
 320  FOR X = 2 TO  LEN (S$) - 1
 325  GOSUB 3000
 328 OV = VI
 330  GOSUB 1000
 332  IF OV = VI THEN  COLOR= 4: GOSUB 3100
 335  GOSUB 2000
 340  NEXT X
 360  NEXT Y
 370  PRINT "VISIBLE TREES: ";VI
 375  PRINT "BEST VIEW SCORE: ";SC
 380  END 

REM Check hidden-ness of tree at X, Y. Current map row is in S$.
REM In order, checks to the west, east, north, and south.
REM If visible, increments the total counter and exits.

 1000 V$ = "0"
 1010  FOR I = 1 TO X - 1
 1020 C$ =  MID$ (S$,I,1)
 1040  IF V$ < C$ THEN V$ = C$
 1050  NEXT I
 1060  IF V$ <  MID$ (S$,X,1) THEN VI = VI + 1: RETURN 
 1100 V$ = "0"
 1110  FOR I =  LEN (S$) TO X + 1 STEP  - 1
 1120 C$ =  MID$ (S$,I,1)
 1130  IF V$ < C$ THEN V$ = C$
 1140  NEXT I
 1150  IF V$ <  MID$ (S$,X,1) THEN VI = VI + 1: RETURN 
 1200 V$ = "0"
 1210  FOR I = 0 TO Y - 1
 1220 C$ =  MID$ (MP$(I),X,1)
 1230  IF V$ < C$ THEN V$ = C$
 1240  NEXT I
 1250  IF V$ <  MID$ (S$,X,1) THEN VI = VI + 1: RETURN 
 1300 V$ = "0"
 1310  FOR I = SZ - 1 TO Y + 1 STEP  - 1
 1320 C$ =  MID$ (MP$(I),X,1)
 1330  IF V$ < C$ THEN V$ = C$
 1340  NEXT I
 1350  IF V$ <  MID$ (S$,X,1) THEN VI = VI + 1
 1360  RETURN 

REM Score scenery for the given tree, same parameters as 1000.
REM Does linear checks to the west, east, north, and south, in that order.

 2000 C$ =  MID$ (S$,X,1)
 2010 N = 0:S = 0:E = 0:W = 0
 2020  FOR I = X - 1 TO 1 STEP  - 1
 2030 W = W + 1
 2040  IF C$ <  =  MID$ (MP$(Y),I,1) THEN I = 1
 2050  NEXT I
 2100  FOR I = X + 1 TO  LEN (S$)
 2110 E = E + 1
 2120  IF C$ <  =  MID$ (MP$(Y),I,1) THEN I =  LEN (S$)
 2130  NEXT I
 2200  FOR I = Y - 1 TO 0 STEP  - 1
 2210 N = N + 1
 2220  IF C$ <  =  MID$ (MP$(I),X,1) THEN I = 0
 2230  NEXT I
 2300  FOR I = Y + 1 TO SZ - 1
 2310 S = S + 1
 2320  IF C$ <  =  MID$ (MP$(I),X,1) THEN I = SZ - 1
 2330  NEXT I
 2400 R = N * S * E * W
 2405  IF R <  = SC GOTO 2450
 2410 A = X:B = Y
 2415 X = SX:Y = SY
 2420  GOSUB 3000
 2425 SC = R:SX = A:SY = B
 2430 X = A:Y = B
 2435  COLOR= 11: GOSUB 3100
 2450  RETURN 

REM Plots the current tree on the screen. Lighter green for taller trees.
REM Visible trees are drawn dark green, see 332.

 3000 C$ =  MID$ (S$,X,1)
 3010  IF C$ < "4" THEN  COLOR= 12: GOTO 3100
 3020  COLOR= 14
 3100  PLOT X - 2,Y - 1
 3110  RETURN 

