#!/bin/sh
cp obj/tmp.decaf decaf-dev/result/tmp.decaf
java -jar decaf-dev/result/decaf.jar -l 4 decaf-dev/result/tmp.decaf > obj/tmp.S
/home/donghy/mips_gcc/bin/mips-sde-elf-gcc -mips32 -c -D__ASSEMBLY__ -g -EL -G0  obj/tmp.S  -o obj/tmp.o
/home/donghy/mips_gcc/bin/mips-sde-elf-ld  -T obj/user.ld  obj/tmp.o obj/libuser.a -o obj/tmp.out
