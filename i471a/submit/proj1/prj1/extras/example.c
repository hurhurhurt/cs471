#include <stdio.h>

static int fact(int n);
static int xfact(int n);
static int aux_fact(int n, int acc);
static int fib(int n);
static int xfib(int n);
static int aux_fib(int n, int f0, int f1);
static int fact(int n){
  return ((n <= 1)) ? (1) : ((n * fact((n - 1))));
}

static int xfact(int n){
  return aux_fact(n, 1);
}

static int aux_fact(int n, int acc){
  return ((n <= 1)) ? (acc) : (aux_fact((n - 1), (n * acc)));
}

static int fib(int n){
  return ((n <= 1)) ? (n) : ((fib((n - 1)) + fib((n - 2))));
}

static int xfib(int n){
  return aux_fib(n, 0, 1);
}

static int aux_fib(int n, int f0, int f1){
  return ((n <= 1)) ? (f1) : (aux_fib((n - 1), f1, (f0 + f1)));
}

int main() {
  printf("%d\n", fact(0));
  printf("%d\n", fact(4));
  printf("%d\n", fact(6));
  printf("%d\n", xfact(0));
  printf("%d\n", xfact(4));
  printf("%d\n", xfact(6));
  printf("%d\n", fib(2));
  printf("%d\n", fib(3));
  printf("%d\n", fib(8));
  printf("%d\n", fib(12));
  printf("%d\n", xfib(2));
  printf("%d\n", xfib(3));
  printf("%d\n", xfib(8));
  printf("%d\n", xfib(12));
}

