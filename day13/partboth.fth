\ Advent of Code 2023, Day 13 Both parts
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Input file changes:
\ - Prepend all map lines with "map: "
\ - Follow each map with a line that says "process"

variable map
variable width
variable height
variable badbits
variable rowtot
variable coltot
create buf 100 cells allot

: reset                 0 width ! 0 height ! here map ! ;
: full-reset            reset 0 rowtot ! 0 coltot ! ;

\ Allocates memory at `here` to store the given line of map data.
: map:                  bl parse
                        width @ 0= if dup width ! then
                        here over allot swap move 
                        1 height +! ;

: map@ ( y x -- n )     swap width @ * + map @ + c@ ;
: rock? ( y x -- b )    map@ [char] # = ;

\ Stores binary representations of each row/column into `buf`.
: rows-to-buf           height @ 0 do 0 pad ! width @ 0 do
                        pad @ 2* j i rock? negate + pad ! loop
                        pad @ buf i cells + ! loop ;
: cols-to-buf           width @ 0 do 0 pad ! height @ 0 do
                        pad @ 2* i j rock? negate + pad ! loop
                        pad @ buf i cells + ! loop ;

\ Counts 1-bits in given number, accumulating into cell at `pad`.
: accumulate-bits       begin dup 0<> while
                        dup 1 and pad +! 2/ repeat drop ;

\ Check for reflection between 'u' stack items behind 'addr' and 'u' and the
\ next 'u' cells starting at 'addr'. The stack items are *not* cleared.
\ Tolerance for reflection is controlled by the `badbits` variable.
: check ( ... addr u -- ... b )
                        dup 0= if 2drop false exit then
                        0 pad ! 0 do dup @ i 2 + pick xor accumulate-bits
                        cell+ loop drop pad @ badbits @ = ;

\ Searches for a reflection point in the given buffer. Returns the index of the
\ reflection or -1 if not found.
: buf-center ( addr u -- u )
                        depth >r dup 0 do
                        buf i cells + @
                        buf i 1+ cells + i 1+ i 3 + pick i - 1- min check
                        if i unloop depth r> do nip loop exit then
                        loop depth 1+ r> do drop loop -1 ;

\ Searches the current map data for a reflected row or column, records into
\ `rowtot` or `coltot` if found, then prepares state for the next map.
: process ( -- )        rows-to-buf height @ buf-center 1+
                        dup 0> if rowtot +! else drop
                        cols-to-buf width @ buf-center 1+
                        coltot +! then reset ;

: summary               rowtot @ 100 * coltot @ + ;

0 badbits ! full-reset
include input summary ." Part 1: " . cr
1 badbits ! full-reset
include input summary ." Part 2: " . cr
bye

