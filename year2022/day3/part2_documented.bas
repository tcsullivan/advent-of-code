REM Advent of Code 2022: Day 3, part 2
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900

REM PT = Priority total
REM SN = String number (capture three strings per group)
REM GN = Group number

 20 PT = 0:SN = 0:GN = 1

REM Open input file. Bytes retrieved with GET.

 30  PRINT  CHR$ (4),"OPEN INPUT"
 40  PRINT  CHR$ (4),"READ INPUT"

 REM Collect the next string. Transferring to the Apple produced
 REM newlines between each byte, so GET D$ discards them.

 100 S$ = ""
 110  GET C$: GET D$
 120  IF  ASC (C$) = 13 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110

REM Repeat if necessary to collect all strings in group of three.

 200  IF SN = 0 THEN X$ = S$:SN = 1: GOTO 100
 210  IF SN = 1 THEN Y$ = S$:SN = 2: GOTO 100
 220 Z$ = S$
 230 SN = 0

 240  PRINT "SEARCHING GROUP ";GN;"'s RUCKSACKS..."
 250 GN = GN + 1

REM Iterate through string X$. Search Y$, if both strings share
REM a character then GOTO 340 to search Z$. If present in all three,
REM GOTO 400. Otherwise, move to next character in X$.

 300  FOR I = 1 TO  LEN (X$)
 310  FOR J = 1 TO  LEN (Y$)
 320  IF  MID$ (X$,I,1) =  MID$ (Y$,J,1) GOTO 340
 330  NEXT J: NEXT I
 340  FOR J = 1 TO  LEN (Z$)
 370  IF  MID$ (X$,I,1) =  MID$ (Z$,J,1) GOTO 400
 380  NEXT J: NEXT I

REM Put badge character in XC$. Calculate priority in PR, then add to total.

 400 XC$ =  MID$ (X$,I,1)
 410 PR =  ASC (XC$)
 420 PR = PR - 64
 430  IF PR > 32 THEN PP = PR - 32
 440  IF PR < 32 THEN PP = PR + 26
 450 PT = PT + PP

REM Print results, continue to next group of strings.
REM If end-of-file, read error is caught and we exit from 900.
REM Would have manually confirmed authentication of each groups' stickers,
REM but I could not figure out reading the keyboard while the input file is
REM opened.

 460  PRINT "FOUND ITEM TYPE FOR GROUP ";GN - 1;"'S BADGES: ";XC$
 470  PRINT "APPLYING AUTHENTICITY STICKERS..."
 480  FOR Q = 1 TO 1000: NEXT Q
 490  PRINT "PRIORITY TOTAL IS NOW ";PT
 499  GOTO 100

 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

