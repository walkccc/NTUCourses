from functools import reduce
from pwn import *


def chinese_remainder(n, a):
    sum = 0
    prod = reduce(lambda a, b: a * b, n)
    for n_i, a_i in zip(n, a):
        p = prod // n_i
        sum += a_i * mul_inv(p, n_i) * p
    return sum % prod


def mul_inv(a, b):
    b0 = b
    x0, x1 = 0, 1
    if b == 1:
        return 1
    while a > 1:
        q = a // b
        a, b = b, a % b
        x0, x1 = x1 - q * x0, x0
    if x1 < 0:
        x1 += b0
    return x1


def iroot(k, n):
    u, s = n, n + 1
    while u < s:
        s = u
        t = (k - 1) * s + n // pow(s, k - 1)
        u = t // k
    return s


def rsa(N, c):
    m = iroot(3, chinese_remainder(N, c))
    FLAG = bytes.fromhex(hex(m)[2:]).decode('utf-8')
    print(FLAG)


if __name__ == "__main__":
    N, c = [], []
    for _ in range(3):
        r = remote('140.112.31.96', 10155)
        r.recvline()
        N.append(int(str(r.recvline(), encoding='utf-8')[4:]))
        c.append(int(str(r.recvline(), encoding='utf-8')[4:]))

    rsa(N, c)
