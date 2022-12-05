REM Advent of Code 2022: Day 5, part 2
REM Written in Applesoft BASIC

 10  DIM ST$(9)
 20  FOR I = 0 TO 8:ST$(I) = "": NEXT I
 60  PRINT  CHR$ (4),"OPEN INPUT"
 70  PRINT  CHR$ (4),"READ INPUT"
 90 J = 1
 91 K = 0
 92 L = 0
 93  DIM AC(3):AC(0) = 0:AC(1) = 0:AC(2) = 0
 94 V = 0
 100  GET C$: GET D$
 110 CV =  ASC (C$)
 120  IF CV > 47 AND CV < 58 GOTO 300
 130  IF J > 0 THEN J = J - 1: GOTO 100
 140  IF CV <  > 32 THEN ST$(K) = C$ + ST$(K)
 150 J = 3
 160 K = K + 1
 170  IF K > 8 THEN K = 0
 180  GOTO 100
 300  FOR I = 0 TO 8
 310  PRINT ST$(I)
 320  NEXT I
 325  PRINT 
 330 CL = 0
 340  GET C$: GET Z$
 350  IF CL = 13 AND  ASC (C$) = 13 GOTO 400
 360 CL =  ASC (C$)
 370  GOTO 340
 400  GET C$: GET Z$
 410 CV =  ASC (C$)
 420  IF CV < 48 OR CV > 57 GOTO 400
 430 V = V * 10 + CV - 48
 440  GET C$: GET Z$
 445 CV =  ASC (C$)
 450  IF CV > 47 AND CV < 58 GOTO 430
 460 AC(L) = V
 465 V = 0
 470 L = L + 1
 480  IF L < 3 GOTO 400
 490 AC(1) = AC(1) - 1
 495 AC(2) = AC(2) - 1
 500 Z$ =  RIGHT$ (ST$(AC(1)),AC(0))
 510 ST$(AC(2)) = ST$(AC(2)) + Z$
 520 Z =  LEN (ST$(AC(1)))
 530  IF AC(0) = Z THEN ST$(AC(1)) = "": GOTO 600
 540 ST$(AC(1)) =  LEFT$ (ST$(AC(1)),Z - AC(0))
 600  FOR I = 0 TO 8
 610  PRINT ST$(I)
 620  NEXT I
 625  PRINT 
 630 L = 0
 640  GOTO 400
 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

