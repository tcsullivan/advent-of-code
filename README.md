# Advent of Code 2022

This year, I plan to complete as many days as possible on my Apple \]\[ GS using Applesoft BASIC. I've devised a system to transfer code and input data to and from the Apple, so all of my code is typed and tested on the machine itself.

Day 5 (Supply Stacks) has my first well-done [visualization](https://www.youtube.com/watch?v=aZpxpvI2hZY). I'm hoping to do more in the future as long as the challenge's complexity (and my time) allows.

## Notes

The Apple communicates with my primary computer over a serial connection with its modem (see [ADTPro's guide](https://www.adtpro.com/connectionsserial.html#MiniDIN8). The modem can run at up to 19,200 baud, which is what I configure it for. I also configure it to add newlines after carriage returns (Apple line endings are only `\r`) and use buffering.

On my main computer, I configure the serial port through `minicom`: 19,200 baud and hardware flow control. For some reason, I also need to configure for 7-bit characters even through the Apple is supposedly set for 8-bit. Not sure what's up there.

I use an ADTPro floppy to load BASIC, then swap for a general floppy to store my input data and programs. Running `PR#2` on the Apple will direct output to the modem, allowing me to `LIST` my finished programs into a `minicom` capture. Through a custom BASIC program I named `SERIN`, the Apple will read data from the modem and write it to a file; this is how I get my input data. `SERIN` writes the input file with `PRINT` statements, which sticks carriage returns between every byte. After writing this, I may have realized how to fix that.

In the future, I will add more notes here on my setup and learned techniques. I'll also add the script for `SERIN`.
