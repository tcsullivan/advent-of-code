REM Advent of Code 2022: Day 3, part 1
REM Written in Applesoft BASIC

 10  ONERR  GOTO 900
 20 PT = 0
 30  PRINT  CHR$ (4),"OPEN INPUT"
 40  PRINT  CHR$ (4),"READ INPUT"
 100 S$ = ""
 110  GET C$: GET D$
 120  IF  ASC (C$) = 13 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110
 200 L =  LEN (S$) / 2
 210 LS$ =  LEFT$ (S$,L)
 220 RS$ =  RIGHT$ (S$,L)
 230 LL =  LEN (LS$)
 240 RL =  LEN (RS$)
 250  FOR I = 1 TO LL
 260  FOR J = 1 TO RL
 270  IF  MID$ (LS$,I,1) =  MID$ (RS$,J,1) GOTO 400
 280  NEXT J
 290  NEXT I
 400 PR =  ASC ( MID$ (LS$,I,1))
 410 PR = PR - 64
 420  IF PR > 32 THEN PP = PR - 32
 430  IF PR < 32 THEN PP = PR + 26
 440 PT = PT + PP
 450  PRINT "FOUND: "; MID$ (LS$,I,1);" PRIO ";PP;"    TOTAL: ";PT
 500  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

