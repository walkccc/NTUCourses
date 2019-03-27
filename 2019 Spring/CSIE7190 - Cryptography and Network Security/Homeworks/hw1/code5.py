from pwn import *
import random
import time
import base64
import numpy as np


def otp1(r):
    random.seed(int(time.time()))

    cipher = str(r.recv(), encoding='utf-8')
    cipher = bytes(str(cipher), encoding='utf-8')
    cipher = base64.b64decode(cipher)
    FLAG = [i ^ random.randint(0, 255) for i in cipher]
    FLAG = [str(chr(i)) for i in FLAG]
    print(''.join(FLAG))


def otp2(r):
    Mat = np.load('keysCiphers.npy')
    Mat = Mat[0:200]

    keys = Mat[:, 0:65]
    ciphers = Mat[:, 65:]

    def XOR(row1, row2):
        return [row1[i] ^ row2[i] for i in range(len(row1))]

    def rowReduce(ciphers, M):

        row_set = set()
        for j in range(M.shape[1]):
            for i in range(M.shape[0]):
                if i not in row_set:
                    header = [] if j == 0 else M[i, 0: j]
                    pivot = -1
                    if 1 not in header and M[i][j] == 1:
                        pivot = i
                        row_set.add(i)
                        break

            for i in range(M.shape[0]):
                if M[i][j] == 1 and i != pivot and i not in row_set:
                    M[i] = XOR(M[pivot], M[i])
                    ciphers[i] = XOR(ciphers[pivot], ciphers[i])

        return ciphers[list(row_set)], M[list(row_set)]

    ciphers, keys = rowReduce(ciphers, keys)

    A = keys.copy().astype(str)
    L = []
    for i in range(A.shape[0]):
        tmp = ''.join(A[i].tolist())
        L.append(int(tmp, 2))

    for i in range(65):
        if L[i] == 1:
            FLAG_idx = i

    FLAG = ''
    for j in range(ciphers.shape[1]):
        FLAG += str(chr(int(ciphers[FLAG_idx][j])))
    print(FLAG)


if __name__ == "__main__":
    r = remote('140.112.31.96', 10152)
    otp1(r)
    otp2(r)
    # r.interactive()
