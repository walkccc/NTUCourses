#!/usr/bin/env python
import os
import time
import random
import hashlib
import secret

def denial():
    print("Oh no my resource is exhausted! Here is the flag:")
    print(secret.flag)
    os._exit(0)

def sha256(content):
    Hash=hashlib.sha256()
    Hash.update(content)
    return Hash.digest()

def challenge():
    randomstring = hex(random.randint(0,2**24))[2:]
    print("Wanna access the service? Solve my challenge first!")
    user = raw_input("Give me an X (<= 20 Bytes) such that sha256(X) ends with {:0>6}: ".format(randomstring)).decode("hex")
    if len(user)>20:
        print("Input too large.")
        os._exit(0)
    hashval = sha256(user).encode("hex")
    if hashval[-6:] == "{:0>6}".format(randomstring):
        print("Challenge Completed. Continue your attempt.")
    else:
        print("You shall not pass! Go away!")
        os._exit(0)

def main():
    challenge()

    d = {}
    x = []
    n = int(raw_input())

    if n<=0 or n>50000:
        print("Too many elements.")
        os._exit(0)

    for i in range(n):
        tmp = int(raw_input())
        if tmp < 0 or tmp > 2**30:
            print("Elements should be within [0,2^30]")
            os._exit(0)
        x += [tmp]

    start = time.time()
    for i in range(n):
        cur = time.time()
        if(cur - start > 0.4):
            denial()
        d[x[i]] = i
    end = time.time()
    #t.cancel()
    print("I survived.")
    print("Elapsed Time: %f" % (end-start))

main()
