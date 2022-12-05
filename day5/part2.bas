REM Advent of Code 2022: Day 5, part 2
REM Written in Applesoft BASIC

REM ST$ is our array of nine strings to track the stacked boxes.

 10  DIM ST$(9)
 20  FOR I = 0 TO 8:ST$(I) = "": NEXT I

REM Clear screen, set error GOTO for end-of-file, and open the input file.

 30  HOME 
 40  ONERR  GOTO 900
 60  PRINT  CHR$ (4),"OPEN INPUT"
 70  PRINT  CHR$ (4),"READ INPUT"

REM J is a byte counter for reading fields (explained below).
REM K tracks the current stack for building the initial configuration.
REM L is the current index in AC.
REM AC is the "action": move AC(0) from AC(1) to AC(2).
REM V is used to build the values stored in AC.

 90 J = 1
 91 K = 0
 92 L = 0
 93  DIM AC(3):AC(0) = 0:AC(1) = 0:AC(2) = 0
 94 V = 0

REM Here, we read in the initial stack configuration.
REM Reminder, GET Z$ scraps bytes that are an artifact to input file xfer.
REM J tracks where the next stack value is. Stack values are three bytes
REM apart, either "] [" or "]\n[". We loop through ST$ as we read stack
REM values, and add to the current stack if we have a letter and not a space.
REM
REM Once a digit is encountered, we know that we have finished reading the
REM initial data.

 100  GET C$: GET Z$
 110 CV =  ASC (C$)
 120  IF CV > 47 AND CV < 58 GOTO 300
 130  IF J > 0 THEN J = J - 1: GOTO 100
 140  IF CV <  > 32 THEN ST$(K) = C$ + ST$(K)
 150 J = 3
 160 K = K + 1
 170  IF K > 8 THEN K = 0
 180  GOTO 100

REM Print the initial stack configuration.

 300  FOR I = 0 TO 8
 310  GOSUB 700
 320  NEXT I

REM Consume input bytes until we are past the blank line and at the
REM instructions. Newlines on the IIgs are carriage returns, '\r'.

 330 CL = 0
 340  GET C$: GET Z$
 350  IF CL = 13 AND  ASC (C$) = 13 GOTO 400
 360 CL =  ASC (C$)
 370  GOTO 340

REM Begin reading and parsing instructions.
REM We just need the three numbers in each instruction, so we consume
REM everything (all non-digits) between.

 400  GET C$: GET Z$
 410 CV =  ASC (C$)
 420  IF CV < 48 OR CV > 57 GOTO 400

REM We've hit a number. Begin parsing that number into V, which was
REM previously set to zero.

 430 V = V * 10 + CV - 48
 440  GET C$: GET Z$
 445 CV =  ASC (C$)
 450  IF CV > 47 AND CV < 58 GOTO 430

REM Put the value into its spot in the action array AC.
REM If we have not finished reading in an action, go back to 400.

 460 AC(L) = V
 465 V = 0
 470 L = L + 1
 480  IF L < 3 GOTO 400

REM Make "to" and "from" indices zero-based.

 490 AC(1) = AC(1) - 1
 495 AC(2) = AC(2) - 1

REM Z$ stores the chunk being moved, and is added to its destination.

 500 Z$ =  RIGHT$ (ST$(AC(1)),AC(0))
 510 ST$(AC(2)) = ST$(AC(2)) + Z$

REM If we are emptying the "from" stack, set it to empty manually (LEFT$
REM would fail otherwise). If not emptying, clip out the removed crates.

 520 Z =  LEN (ST$(AC(1)))
 530  IF AC(0) = Z THEN ST$(AC(1)) = "": GOTO 600
 540 ST$(AC(1)) =  LEFT$ (ST$(AC(1)),Z - AC(0))

REM Time to update the visualization. Only update the two changed columns.
REM Then, go back to 400 for the next instruction.
REM When reading there fails at the end of the input file, the program will
REM jump to 900 to exit.

 600 I = AC(1): GOSUB 700
 610 I = AC(2): GOSUB 700
 630 L = 0
 640  GOTO 400

REM Stack rendering routine, expects index I into stack data ST$.
REM Initial X and Y coordinates are set. GOTO 780 for return if stack is empty.

 700 X = I * 4 + 1
 705 Y = 25
 706 LE =  LEN (ST$(I))
 708  IF LE = 0 GOTO 780

REM Clear text above the current stack, in case the old stack was higher.
REM VTAB and HTAB position the cursor. The semicolon in the PRINT statement
REM omits the ending newline.

 710  FOR Z = 1 TO 24 - LE
 712  VTAB Z
 714  HTAB X
 716  PRINT "   ";
 718  NEXT Z

REM Build the stack from bottom to top.
REM 760 exits if the stack is too tall.

 720  FOR Z = 1 TO LE
 730  VTAB Y - 1
 735  HTAB X
 740  PRINT "["; MID$ (ST$(I),Z,1);"]";
 750 Y = Y - 1
 760  IF Y = 1 THEN  RETURN 
 770  NEXT Z
 780  RETURN 

REM We land here after end-of-file. Close the file and exit.

 900  PRINT  CHR$ (4),"CLOSE"
 910  END 

