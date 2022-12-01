REM Advent of Code 2022: Day 1, part 2
REM Written in Applesoft BASIC

REM ONERR will GOTO 900 on any error. For this program, the only error should be
REM reaching the end of the input file.

 10  ONERR  GOTO 900

REM Initialize the highest calories array and current calorie count.

 20  DIM CALS(5):CURR = 0

REM Open the input file for reading. Printing CHR$(4) causes the following text
REM to be executed by DOS, which is required for file operations.
REM GET commands after these will retrieve bytes from the file.

 30  PRINT  CHR$ (4),"OPEN INPUT"
 40  PRINT  CHR$ (4),"READ INPUT"

REM The "main loop".
REM Builds string S$ from characters read from the input file. When a carriage
REM return (13 in ASCII) is encountered, the line has ended and is ready to be
REM parsed.
REM `GET D$` is used to discard every other character in the file. Some quirk
REM of the serial transfer placed carriage returns between each byte, so these
REM need to be removed.

 100 S$ = ""
 110  GET C$
 115  GET D$
 120  IF  ASC (C$) = 13 GOTO 200
 130 S$ = S$ + C$
 140  GOTO 110

REM Convert the string to a number. If it becomes zero, then an empty string
REM was parsed: the current elf's calorie count is complete (GOTO 300).
REM Otherwise, add to the total and fetch the next string.

 200 V =  VAL (S$)
 210  IF V = 0 GOTO 300
 220 CURR = CURR + V
 230  GOTO 100

REM Manually sort the CALS array, which stores the top five calorie counts.
REM If CURR belongs at index I, the lower calorie counts are shifted down a
REM place and CURR is inserted. This is followed by printing the top three
REM calorie counts.

 300  FOR I = 0 TO 5
 310  IF CURR = CALS(I) GOTO 360
 320  IF CURR < CALS(I) THEN  NEXT I
 330  FOR J = 3 TO I STEP  - 1:CALS(J + 1) = CALS(J): NEXT J
 340 CALS(I) = CURR
 350  PRINT CALS(0),CALS(1),CALS(2)

REM Reset the current calorie count, then begin reading the next elf's data.

 360 CURR = 0
 370  GOTO 100

REM End-of-file reached. Close the file, and print the total of the top three
REM calorie counts.

 900  PRINT  CHR$ (4),"CLOSE"
 910  PRINT CALS(0) + CALS(1) + CALS(2)
 920  END 

