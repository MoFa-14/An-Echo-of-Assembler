# a default target that builds all tasks
all: task1 task2.1 task2.2 task2.3

# compile task1.asm and asm_io.asm using nasm
src/task1.o: src/task1.asm
	nasm -f elf -I src/ src/task1.asm -o src/task1.o

src/asm_io.o: src/asm_io.asm
	nasm -f elf -I src/ src/asm_io.asm -o src/asm_io.o

# compile driver.c using gcc for all tasks
src/driver.o: src/driver.c
	gcc -m32 -c src/driver.c -o src/driver.o

# link task1 object files together with driver.o and asm_io.o
task1: src/task1.o src/asm_io.o src/driver.o
	gcc -m32 src/driver.o src/task1.o src/asm_io.o -o task1

# compile task2.1.asm using nasm
src/task2.1.o: src/task2.1.asm
	nasm -f elf -I src/ src/task2.1.asm -o src/task2.1.o

# link task2.1 object files together with driver.o and asm_io.o
task2.1: src/task2.1.o src/asm_io.o src/driver.o
	gcc -m32 src/driver.o src/task2.1.o src/asm_io.o -o task2.1

# compile task2.2.asm using nasm
src/task2.2.o: src/task2.2.asm
	nasm -f elf -I src/ src/task2.2.asm -o src/task2.2.o

# link task2.2 object files together with driver.o and asm_io.o
task2.2: src/task2.2.o src/asm_io.o src/driver.o
	gcc -m32 src/driver.o src/task2.2.o src/asm_io.o -o task2.2

# compile task2.3.asm using nasm
src/task2.3.o: src/task2.3.asm
	nasm -f elf -I src/ src/task2.3.asm -o src/task2.3.o

# link task2.3 object files together with driver.o and asm_io.o
task2.3: src/task2.3.o src/asm_io.o src/driver.o
	gcc -m32 src/driver.o src/task2.3.o src/asm_io.o -o task2.3

# clean target to remove object files and executables
clean:
	rm -f src/*.o task1 task2.1 task2.2 task2.3
