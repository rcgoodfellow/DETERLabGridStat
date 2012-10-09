cc -c ckml.c -o ckml.o
cc -Wall -Wextra -std=c99 kmlServer.c ckml.o -lpthread -o ks -DDEBUG
