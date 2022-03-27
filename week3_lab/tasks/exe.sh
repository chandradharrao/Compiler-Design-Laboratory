#!/bin/bash

rm -f exe sym_tab.o unitTest1.o  
gcc -c sym_tab.c
gcc -c unitTest1.c
gcc sym_tab.o unitTest1.o -o a.out
./a.out
