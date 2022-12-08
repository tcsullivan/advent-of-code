REM Advent of Code 2022: Day 6, part 1 and 2
REM Written in Applesoft BASIC

 5  HOME 
 10 R1 = 3
 20 R2 = 13
 30 G1 = 0
 40 G2 = 0
 50 M = 0
 50  PRINT  CHR$ (4),"OPEN INPUT"
 60  PRINT  CHR$ (4),"READ INPUT"
 70  ONERR  GOTO 900

REM Print some fun messages, going for a hacker feel.
REM The routine at 1000 spins an empty FOR I = 0 TO A loop for a delay.

 100  PRINT "INITIALIZING COMMUNICATION SYSTEM";
 105 A = 350
 110  FOR I = 0 TO 6
 120  GOSUB 1000
 130  PRINT ".";
 140  NEXT I
 150  PRINT 
 200  PRINT "OPENING SIGNAL DATASTREAM";
 210  FOR I = 0 TO 6
 220  GOSUB 1000
 230  PRINT ".";
 240  NEXT I
 250  PRINT : PRINT
 300  PRINT "SCANNING FOR START-OF-PACKET MARKER:"

 310  HTAB 1
 320  VTAB 8
 330  PRINT "||||";
 340  HTAB 1
 350  VTAB 10
 360  PRINT "||||||||||||||";


REM Main loop: Print the current string. If it can be checked for uniqueness,
REM GOTO 500 (which comes back to 440). At 440, we add the next character to
REM the string and trim off the end if its too long.

 400  HTAB 1
 403  VTAB 9
 406  PRINT S$;
 410  GET C$
 413 S$ = C$ + S$
 420  IF  LEN (S$) > 40 THEN S$ =  MID$ (S$,1,40)
 430  IF M > 0 THEN M = M - 1: GOTO 400
 440  IF  G1 = 0 AND LEN (S$) >  = 4 THEN GOSUB 500
 450  IF  G2 = 0 AND LEN (S$) >  = 14 THEN GOSUB 2200
 460  IF G1 = 1 AND G2 = 1 GOTO 900
 480  GOTO 400

REM Here, we check for matching characters. It's hard-coded because there are
REM only a few combinations. A little ASCII art "connects" the matched bytes.
REM GOTO 700 if all unique, otherwise back to 440 for the next character.

 500 R1 = R1 + 1
 500  HTAB 1
 510  VTAB 7
 530  IF  MID$ (S$,1,1) =  MID$ (S$,2,1) THEN  PRINT "/\  ";
 540  IF  MID$ (S$,1,1) =  MID$ (S$,3,1) THEN  PRINT "/-\ ";
 550  IF  MID$ (S$,1,1) =  MID$ (S$,4,1) THEN  PRINT "/--\";
 560  IF  MID$ (S$,2,1) =  MID$ (S$,3,1) THEN  PRINT " /\ ";
 570  IF  MID$ (S$,2,1) =  MID$ (S$,4,1) THEN  PRINT " /-\";
 580  IF  MID$ (S$,3,1) =  MID$ (S$,4,1) THEN  PRINT "  /\";
 590  PRINT "    ";
 700  HTAB 1
 710  VTAB 13
 715 A = 1300
 718 G1 = 1
 720  PRINT "MARKER FOUND AT INDEX ";R;"."
 599  RETURN

REM I keep the exit routine at 900 out of habit.

 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

REM The delay routine.

 1000  FOR Z = 0 TO A: NEXT Z
 1010  RETURN 

REM Search for a matching pair. If found, store 2nd index in M.

 2200 I = 1
 2205 M = 0
 2210  FOR J = I + 1 TO 14
 2220  IF  MID$ (S$,I,1) =  MID$ (S$,J,1) THEN M = J:J = 14
 2230  NEXT J
 2240  IF M <  > 0 GOTO 2300

REM If no matches, move to next index and repeat.
REM If we've gone through all indices, marker found. GOTO 2400.

 2250 I = I + 1
 2260  IF I < 14 GOTO 2200

 2270  HTAB 1
 2275  VTAB 23
 2280  G2 = 1
 2285  PRINT "MESSAGE FOUND AT INDEX ";R"."
 2290  RETURN

REM A match was found. Show dashes between the two characters.

 2300  HTAB I
 2310  VTAB 11
 2314  PRINT "              ";
 2318  HTAB I
 2320  FOR J = I TO M
 2330  PRINT "-";
 2340  NEXT J
 2345 M = 14 - M
 2350  RETURN

