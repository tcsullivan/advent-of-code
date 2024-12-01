\ Advent of Code 2023, Day 4 Part 2
\ Written by Clyne Sullivan <clyne@bitgloo.com>
\ Released under the Unlicense.
\
\ Usage: gforth part2.fth

5 constant wincnt
8 constant mycnt

: Card    [char] : parse 2drop ;
: |       ;
: card,   wincnt mycnt + 0 do , loop ;
: +card   wincnt mycnt + cells + ;
: winners mycnt cells + ;

: contains? ( c-addr u n -- b )
  -rot 0 do
  dup i cells + @
  2 pick = if unloop 2drop true exit then
  loop 2drop false ;

: check ( c-addr -- n )
  0 swap
  mycnt 0 do
  dup winners wincnt
  2 pick i cells + @
  contains? if swap 1+ swap then
  loop drop ;

: sum-stack
  depth 1- 0 do + loop ;

create cards
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53 card,
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19 card,
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1 card,
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83 card,
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36 card,
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11 card,
here constant cardsend

cardsend cards - mycnt wincnt + cells /
constant cardcount

: init-wins 0 do 1 , loop ;
create wins cardcount init-wins

: sum-wins 0 cardcount 0 do wins i cells + @ + loop ;

: add-wins ( count i -- n )
  cells wins +
  dup @ rot 0 ?do
  swap cell+ 2dup +! swap loop
  2drop ;

: check-cards
  cards cardcount 0 do
  dup check i add-wins
  +card loop drop ;

check-cards
sum-wins . cr
bye
