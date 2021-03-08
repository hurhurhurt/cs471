# simple factorial
def fact(n) (n <= 1) ? 1 : n * fact(n - 1)

fact(0) fact(4)  fact(6)

# tail-recursive factorial
def xfact(n) aux_fact(n, 1)

def aux_fact(n, acc) (n <= 1) ? acc : aux_fact(n - 1, n*acc)

xfact(0) xfact(4)  xfact(6)

# simple fibonacci
def fib(n) (n <= 1) ? n : fib(n - 1) + fib(n - 2)

fib(2) fib(3) fib(8) fib(12)

# tail-recursive fibonacci
def xfib(n) aux_fib(n, 0, 1)

def aux_fib(n, f0, f1) (n <= 1) ? f1 : aux_fib(n - 1, f1, f0 + f1)

xfib(2) xfib(3) xfib(8) xfib(12)


