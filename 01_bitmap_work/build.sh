#!/usr/bin/bash
gcc -o ./rayse.bin -g -I./src -Wall -DDG_NO_LUA src/main.c $(ls src/util/*.c) -lm -lpthread
