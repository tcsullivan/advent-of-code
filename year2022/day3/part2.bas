REM Advent of Code 2022: Day 3, part 2
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900
 20 PT = 0:SN = 0:GN = 1
 30  PRINT  CHR$ (4),"OPEN INPUT"
 40  PRINT  CHR$ (4),"READ INPUT"
 100 S$ = ""
 110  GET C$: GET D$
 120  IF  ASC (C$) = 13 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110
 200  IF SN = 0 THEN X$ = S$:SN = 1: GOTO 100
 210  IF SN = 1 THEN Y$ = S$:SN = 2: GOTO 100
 220 Z$ = S$
 230 SN = 0
 240  PRINT "SEARCHING GROUP ";GN;"'s RUCKSACKS..."
 250 GN = GN + 1
 300  FOR I = 1 TO  LEN (X$)
 310  FOR J = 1 TO  LEN (Y$)
 320  IF  MID$ (X$,I,1) =  MID$ (Y$,J,1) GOTO 340
 330  NEXT J: NEXT I
 340  FOR J = 1 TO  LEN (Z$)
 370  IF  MID$ (X$,I,1) =  MID$ (Z$,J,1) GOTO 400
 380  NEXT J: NEXT I
 400 XC$ =  MID$ (X$,I,1)
 410 PR =  ASC (XC$)
 420 PR = PR - 64
 430  IF PR > 32 THEN PP = PR - 32
 440  IF PR < 32 THEN PP = PR + 26
 450 PT = PT + PP
 460  PRINT "FOUND ITEM TYPE FOR GROUP ";GN - 1;"'S BADGES: ";XC$
 470  PRINT "APPLYING AUTHENTICITY STICKERS..."
 480  FOR Q = 1 TO 1000: NEXT Q
 490  PRINT "PRIORITY TOTAL IS NOW ";PT
 499  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

