.PHONY: all clean run build

all: checker

build: checker

run: checker
	./checker

maze.o: maze.asm
	nasm -f elf $^ -o $@

check_maze.o: check_maze.c
	gcc -c -g -m32 -no-pie $^ -o $@

checker: check_maze.o  maze.o
	gcc -m32 -g -no-pie $^ -o $@
	rm *.o

clean:
	rm -f checker
	rm -f output/maze_*