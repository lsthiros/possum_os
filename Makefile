all: test.bin

startup.o: startup.s
	arm-none-eabi-as -mcpu=arm926ej-s -g startup.s -o startup.o

test.o: test.c
	arm-none-eabi-gcc -c -mcpu=arm926ej-s -g test.c -o test.o

test.elf: test.o startup.o
	arm-none-eabi-ld -T test.ld test.o startup.o -o test.elf

test.bin: test.elf
	arm-none-eabi-objcopy -O binary test.elf test.bin

clean:
	rm -f test.o startup.o test.elf test.bin