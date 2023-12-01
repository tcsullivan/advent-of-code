REM Advent of Code 2022: Day 11 part 1
REM Written in Applesoft BASIC

 10  DIM MK(10,25)
 20  DIM MS(10)
 30  DIM IC(10)
 40 MI =  - 1
 50 M$ = ""
 70  PRINT  CHR$ (4),"OPEN INPUT"
 80  PRINT  CHR$ (4),"READ INPUT"
 90  ONERR  GOTO 900
 100 S$ = ""
 110  GET C$
 120  IF C$ < " " GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110
 200  IF  LEN (S$) = 0 GOTO 300
 205  PRINT S$
 210  IF  LEFT$ (S$,6) = "Monkey" GOTO 400
 220  IF  LEFT$ (S$,4) = "  St" GOTO 500
 230  IF  LEFT$ (S$,4) = "  Op" GOTO 700
 235 Z = 0
 240  FOR I = 1 TO  LEN (S$)
 245 C$ =  MID$ (S$,I,1)
 250  IF C$ >  = "0" AND C$ <  = "9" THEN Z = I:I =  LEN (S$)
 260  NEXT I
 270 V =  VAL ( MID$ (S$,Z, LEN (S$) - Z + 1))
 280 M$ =  CHR$ (V) + M$
 290  GOTO 100
 300  FOR I = 1 TO  LEN (M$)
 310 MK(MI,I - 1) =  ASC ( MID$ (M$,I,1))
 320  NEXT I
 330 MS(MI) =  LEN (M$) - 1
 340 M$ = ""
 350  GOTO 100
 400 MI = MI + 1
 410  GOTO 100
 500 S$ =  MID$ (S$,2, LEN (S$) - 1)
 510  IF  LEN (S$) = 0 GOTO 100
 520  IF  LEFT$ (S$,1) >  = "0" AND  LEFT$ (S$,1) <  = "9" GOTO 540
 530  GOTO 500
 540 V =  VAL (S$)
 550 M$ = M$ +  CHR$ (V)
 570 S$ =  MID$ (S$,2, LEN (S$) - 1)
 580  IF  LEN (S$) = 0 GOTO 100
 590  IF  LEFT$ (S$,1) < "0" OR  LEFT$ (S$,1) > "9" GOTO 500
 600  GOTO 570
 700 S$ =  MID$ (S$,2, LEN (S$) - 1)
 710  IF  LEN (S$) = 0 GOTO 100
 720  IF  LEFT$ (S$,1) = "=" GOTO 740
 730  GOTO 700
 740 O$ =  MID$ (S$,7,1)
 750  IF  MID$ (S$,9,1) = "o" THEN V = 0: GOTO 770
 760 V =  VAL ( MID$ (S$,9, LEN (S$) - 8))
 770 M$ =  CHR$ (V) + O$ + M$
 780  GOTO 100
 900  PRINT  CHR$ (4),"CLOSE"
 910  POKE 216,0
 920  CALL  - 3288
 925  GOTO 2000
 930 SM = 1
 940  FOR I = 0 TO MI
 950 SM = SM * MK(I,2)
 960  NEXT I
 1000  FOR I = 0 TO MI
 1005  PRINT MS(I);": ";
 1010  FOR J = 0 TO MS(I)
 1020  PRINT MK(I,J);" ";
 1030  NEXT J
 1040  PRINT 
 1050  NEXT I
 2000  FOR R = 1 TO 20
 2005  PRINT "TURN ";R;"..."
 2010  FOR I = 0 TO MI
 2018  IF MS(I) < 5 GOTO 2160
 2020  FOR J = 5 TO MS(I)
 2030 W = MK(I,J)
 2040 O = MK(I,3)
 2050  IF O = 0 THEN O = W
 2060  IF MK(I,4) = 42 THEN W = W * O
 2070  IF MK(I,4) = 43 THEN W = W + O
 2080 W =  INT (W / 3)
 2090 D =  INT (W / MK(I,2))
 2100  IF W = D * MK(I,2) THEN K = MK(I,1): GOTO 2120
 2110 K = MK(I,0)
 2120 MS(K) = MS(K) + 1
 2130 MK(K,MS(K)) = W
 2135 MK(I,J) = 0
 2140  NEXT J
 2150 IC(I) = IC(I) + MS(I) - 4
 2160 MS(I) = 4
 2170  NEXT I
 2180  NEXT R
 2200  FOR I = 0 TO MI
 2210  PRINT "MONKEY ";I;" TOSSED ";IC(I);" TIMES."
 2220  NEXT I
 2230  END 
 2500  FOR I = 0 TO MI
 2510  FOR J = 0 TO MS(I)
 2520  PRINT MK(I,J);" ";
 2530  NEXT J
 2540  PRINT 
 2550  NEXT I
 2560  RETURN 

