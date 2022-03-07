#!/usr/bin/bash
gcc -o ./rayse.bin -g -I./src -Wall -Wno-missing-braces -Wno-parentheses -DDG_NO_LUA src/main.c $(ls src/util/*.c) -lm -lpthread -lSDL2
