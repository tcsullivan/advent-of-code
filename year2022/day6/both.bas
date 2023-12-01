REM Advent of Code 2022: Day 6, part 1 and 2
REM Written in Applesoft BASIC

 5  HOME 
 10 R = 0
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
 250  PRINT 
 260  PRINT 
 300  PRINT "SCANNING FOR START-OF-PACKET MARKER:"

REM Show bars above and below the four characters being tested for part one.

 310  HTAB 1
 320  VTAB 8
 330  PRINT "||||";
 340  HTAB 1
 350  VTAB 10
 360  PRINT "||||";

REM Main loop: Print the current string. If it can be checked for uniqueness,
REM GOTO 500 (which comes back to 440). At 440, we add the next character to
REM the string and trim off the end if its too long.

 400  HTAB 1
 410  VTAB 9
 420  PRINT S$;
 430  IF  LEN (S$) >  = 4 GOTO 500
 440  GET C$
 450 S$ = C$ + S$
 455  IF  LEN (S$) > 40 THEN S$ =  MID$ (S$,1,40)

REM Delay a little for visual effect, count the added character, then repeat.

 460 A = 80
 470  GOSUB 1000
 475 R = R + 1
 480  GOTO 400

REM Here, we check for matching characters. It's hard-coded because there are
REM only a few combinations. A little ASCII art "connects" the matched bytes.
REM GOTO 700 if all unique, otherwise back to 440 for the next character.

 500  HTAB 1
 510  VTAB 7
 530  IF  MID$ (S$,1,1) =  MID$ (S$,2,1) THEN  PRINT "/\  ";: GOTO 600
 540  IF  MID$ (S$,1,1) =  MID$ (S$,3,1) THEN  PRINT "/-\ ";: GOTO 600
 550  IF  MID$ (S$,1,1) =  MID$ (S$,4,1) THEN  PRINT "/--\";: GOTO 600
 560  IF  MID$ (S$,2,1) =  MID$ (S$,3,1) THEN  PRINT " /\ ";: GOTO 600
 570  IF  MID$ (S$,2,1) =  MID$ (S$,4,1) THEN  PRINT " /-\";: GOTO 600
 580  IF  MID$ (S$,3,1) =  MID$ (S$,4,1) THEN  PRINT "  /\";: GOTO 600
 590  PRINT "    ";
 595  GOTO 700
 600  GOTO 440

REM Part 1 complete! Indicate that part 2 is beginning...

 700  HTAB 1
 710  VTAB 13
 715 A = 1300
 720  PRINT "MARKER FOUND AT INDEX ";R;"."
 725  GOSUB 1000
 730  PRINT 
 740  PRINT "ENGAGING FULL-SPEED SEARCH FOR START-OF-MESSAGE MARKER:"
 750  GOSUB 1000
 760  GOTO 2000

REM I keep the exit routine at 900 out of habit.

 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

REM The delay routine.

 1000  FOR Z = 0 TO A: NEXT Z
 1010  RETURN 

REM Print bars for the 14-character window.

 2000  HTAB 1
 2010  VTAB 19
 2020  PRINT "||||||||||||||";
 2030  HTAB 1
 2040  VTAB 21
 2050  PRINT "||||||||||||||";

REM Re-open the input data and reset variables (var M is new).

 2060  PRINT  CHR$ (4),"CLOSE"
 2070  PRINT  CHR$ (4),"OPEN INPUT"
 2080  PRINT  CHR$ (4),"READ INPUT"
 2090 S$ = "":R = 0
 2095 M = 0

REM Print the string, then add and count the next character.

 2100  HTAB 1
 2110  VTAB 20
 2120  PRINT S$;
 2130  GET C$
 2140 S$ = C$ + S$
 2145 R = R + 1

REM Same checks as part one, except for 2170 which skips M checks.
REM See 2345 for explanation.

 2150  IF  LEN (S$) < 14 GOTO 2100
 2160  IF  LEN (S$) > 40 THEN S$ =  MID$ (S$,1,40)
 2170  IF M > 0 THEN M = M - 1: GOTO 2100

REM Prepare to search for matches.

 2190 I = 1
 2200 M = 0

REM Search for a matching pair. If found, store 2nd index in M.

 2210  FOR J = I + 1 TO 14
 2220  IF  MID$ (S$,I,1) =  MID$ (S$,J,1) THEN M = J:J = 14
 2230  NEXT J
 2240  IF M <  > 0 GOTO 2300

REM If no matches, move to next index and repeat.
REM If we've gone through all indices, marker found. GOTO 2400.

 2250 I = I + 1
 2260  IF I < 14 GOTO 2200
 2270  GOTO 2400

REM A match was found. Show dashes between the two characters.

 2300  HTAB I
 2310  VTAB 18
 2314  PRINT "              ";
 2318  HTAB I
 2320  FOR J = I TO M
 2330  PRINT "-";
 2340  NEXT J

REM M becomes the number of characters to skip/shift in the input string.
REM E.g. if indices 1 and 3 matched, they will continue to be in the 14-char
REM window for the next 11 iterations. Skip those.

 2345 M = 14 - M
 2350  GOTO 2100

REM Yay, we did it!

 2400  HTAB 1
 2410  VTAB 23
 2420  PRINT "MESSAGE FOUND AT INDEX ";R"."
 2425  GOSUB 1000
 2430  GOTO 900

