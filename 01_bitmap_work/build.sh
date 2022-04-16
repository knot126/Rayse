#!/usr/bin/bash
gcc -std=c2x -o ./rayse.exec -g -I./src -Wall -Wno-missing-braces -Wno-parentheses -DDG_NO_LUA src/main.c $(ls src/util/*.c) -lm -lpthread -lSDL2
