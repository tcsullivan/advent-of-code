part1:
	@sed -f sed.txt input > body
	@cat header body footer > prog.c
	@gcc -O3 prog.c -o prog
	@./prog

part2:
	@sed -f sed2.txt input > body
	@cat header2 body footer2 > prog.c
	@gcc -O3 prog.c -o prog
	@./prog
