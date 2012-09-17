clang -c ckml.c -o ckml.o
clang -Wall -Wextra kmlServer.c ckml.o -lpthread -o ks -DDEBUG
