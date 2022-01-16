clang -o ./rayse.bin -I./src -Wall -DDG_NO_LUA src/main.c $(ls src/util/*.c) -lm -lpthread
