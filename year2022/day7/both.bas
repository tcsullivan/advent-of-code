REM Advent of Code 2022: Day 7, part 1 and 2
REM Written in Applesoft BASIC

REM Usual initialization. SPEED= sets the text speed; I play with it
REM and some empty FOR loops during the program for artistic effect.

 10  ONERR  GOTO 700
 20  PRINT  CHR$ (4),"OPEN INPUT"
 30  PRINT  CHR$ (4),"READ INPUT"
 40  HOME 
 50  SPEED= 170

REM DN$ and DS are a index-matched "map" of paths and sizes. A size of
REM 200 accommodated my input.
REM W$ stores the current working directory.

 100  DIM DN$(200)
 110  DIM DS(200)
 120  FOR I = 0 TO 199:DN$(I) = "": NEXT I
 130  FOR I = 0 TO 199:DS(I) = 0: NEXT I
 140 W$ = "/"

REM Main loop: consume a line of input, display it, and then handle
REM either the "ls" or "cd" that it is.

 200  GOSUB 4000
 210  PRINT "$";
 215  FOR I = 0 TO 1000: NEXT I
 218  SPEED= 70: PRINT  RIGHT$ (S$, LEN (S$) - 1): SPEED= 170
 220  IF  LEFT$ (S$,4) = "$ cd" GOTO 300
 230  GOTO 500

REM "cd" routine. If the path starts with '/', then clear the working
REM directory so we return to root.
REM If starting with a '.', GOTO 350 to handle backing up a level.
REM Otherwise, append to the working directory.

 300 C$ =  MID$ (S$,6,1)
 305  IF  ASC (C$) = 47 THEN W$ = ""
 310  IF  ASC (C$) = 46 GOTO 350
 320 W$ = W$ +  MID$ (S$,6, LEN (S$) - 5)
 330  IF  ASC ( RIGHT$ (W$,1)) <  > 47 THEN W$ = W$ + "/"
 340  GOTO 400

 350 W$ =  LEFT$ (W$, LEN (W$) - 1)
 360  IF  RIGHT$ (W$,1) <  > "/" GOTO 350
 370  GOTO 200

REM Call 2000 to create a size entry for this directory if it does not
REM exist.

 400 S$ = W$
 410  GOSUB 2000
 420  GOTO 200

 REM "ls" routine. Leave the loop if we reach the next command; skip dirs.

 500 V = 0
 510  GOSUB 4000
 515  IF  LEFT$ (S$,1) = "$" GOTO 210
 520  PRINT S$
 530  IF  LEFT$ (S$,3) = "dir" GOTO 510

REM Call 3000 to add file's size to relevant directorys' totals.

 540 V =  VAL (S$)
 550 S$ = W$
 560  GOSUB 3000
 570  GOTO 510

REM We will land here once the file has been completely read. Do the
REM search for part 1, summing into T.

 700 T = 0
 710  FOR I = 0 TO 199
 720  IF  LEN (DN$(I)) = 0 THEN I = 199: GOTO 740
 730  IF DS(I) <  = 100000 THEN T = T + DS(I)
 740  NEXT I
 745  PRINT 
 750  PRINT "part 1: ";T;" bytes"

REM Part 2 is at 5000. It will come back to 900 to exit.

 760  GOTO 5000

 900  PRINT  CHR$ (4),"CLOSE"
 910  SPEED= 255
 920  END 

REM Subroutine: Fetches the size of directory S$, putting it in V.

 1000 V = 0
 1010  FOR I = 0 TO 199
 1020  IF DN$(I) = S$ THEN V = DS(I):I = 199
 1030  NEXT I
 1040  RETURN 

REM Subroutine: Initializes new entry for directory S$.

 2000  FOR I = 0 TO 199
 2010  IF DN$(I) = S$ THEN  PRINT "ERROR": END 
 2020  IF  LEN (DN$(I)) = 0 THEN DN$(I) = S$:DS(I) = 0:I = 199
 2030  NEXT I
 2040  RETURN 

REM Subroutine: Adds size V to entry for directory S$ and its parents.

 3000  FOR I = 0 TO 199
 3010 L =  LEN (S$)
 3015 M =  LEN (DN$(I))
 3020  IF  LEN (DN$(I)) = 0 THEN I = 199: GOTO 3040
 3030  IF L >  = M AND  LEFT$ (S$,M) = DN$(I) GOTO 3060
 3040  NEXT I
 3050  RETURN 
 3060 DS(I) = DS(I) + V
 3080  GOTO 3040

REM Subroutine: Reads next line of input from the file.

 4000 S$ = ""
 4010  GET C$
 4020  IF  ASC (C$) < 32 GOTO 4050
 4030 S$ = S$ + C$
 4040  GOTO 4010
 4050  RETURN 

REM Part 2. Start by printing total filesystem size.

 5000  PRINT "$ ";
 5002  SPEED= 70: PRINT "df -h": SPEED= 170
 5004  FOR I = 0 TO 1000: NEXT I
 5006 S$ = "/"
 5010  GOSUB 1000
 5015  PRINT V

REM Calculate free memory requirements.

 5020 UN = 70000000 - V
 5030 RE = 30000000 - UN
 5040 DE = 99999999
 5100  PRINT "$";
 5110  SPEED= 70: PRINT " cleanup": SPEED= 170
 5120  FOR I = 0 TO 1000: NEXT I
 5130  PRINT "NEED TO FREE ";RE;" BYTES..."

REM The actual work: iterate for smallest entry that is at least RE bytes.

 5200  FOR I = 0 TO 199
 5210  IF  LEN (DN$(I)) = 0 THEN I = 199: GOTO 5230
 5220  IF DS(I) > RE AND DS(I) < DE THEN DE = DS(I)
 5230  NEXT I

REM All done!

 5240  PRINT "FREED ";DE;" BYTES."
 5250  GOTO 900

REM Debug subroutine: print all contents of directory/size map.

 6000  FOR I = 0 TO 199
 6010  IF  LEN (DN$(I)) = 0 THEN I = 199: GOTO 6030
 6020  PRINT DN$(I),DS(I)
 6030  NEXT I
 6040  RETURN 

