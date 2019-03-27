#!/usr/bin/env python3

import os
import time
from base64 import b64encode, b64decode

from Cryptodome.Util.Padding import pad, unpad
from Cryptodome.Cipher import AES

from secret import secret_msg, secret_flag

BLOCK_SIZE = 16
KEY_SIZE = 32
NONCE_SIZE = 32

def getRandom(n):
    val = os.urandom(n)
    return val

def encrypt(msg, iv, key):
    msg = pad(msg, BLOCK_SIZE)
    aes = AES.new(key=key, mode=AES.MODE_CBC, iv=iv)
    ciphertext = aes.encrypt(msg)
    return b64encode(ciphertext)

def decrypt(msg, iv, key):
    aes = AES.new(key=key, mode=AES.MODE_CBC, iv=iv)
    msg = b64decode(msg)
    plaintext = aes.decrypt(msg)
    plaintext = unpad(plaintext, BLOCK_SIZE)
    return bytes(plaintext)

def menu():
    print('===================================')
    print('    Neuman-Stubblebine Protocol    ')
    print('===================================')
    print('  1. Initial Authentication        ')
    print('  2. Subsequent Authentication     ')
    print('  3. Exit                          ')
    print('===================================')

def getKeys():
    global K_AS, K_BS, K_AB, IV_A, IV_B, IV_AB

    f = open('/tmp/key.txt', 'r')
    keys = f.read().strip().split('\n')
    f.close()

    K_AS = b64decode(keys[0])
    K_BS = b64decode(keys[1])
    K_AB = b64decode(keys[2])
    IV_A = b64decode(keys[3])
    IV_B = b64decode(keys[4])
    IV_AB = b64decode(keys[5])

    print('IV_AB:', str(b64encode(IV_AB), 'utf-8'))

def server(sender, Ns, enc_msg):
    if sender == 'A':
        Ks = K_AS
        IVs = IV_A
        Kr = K_BS
        IVr = IV_B
    elif sender == 'B':
        Ks = K_BS
        IVs = IV_B
        Kr = K_AS
        IVr = IV_A
    else:
        print('Not a valid user!')
        exit(-1)

    try:
        msg = str(decrypt(enc_msg, IVs, Ks), 'utf-8').split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(msg) != 3:
        print('Invalid msg!')
        exit(-1)
    receiver, Nr, Ts = tuple(msg)

    msg1 = bytes('{}||{}||{}'.format(receiver, str(b64encode(K_AB), 'utf-8'), Ts), 'utf-8')
    msg1 = encrypt(msg1, IVs, Ks)
    msg2 = bytes('{}||{}||{}||{}'.format(sender, Nr, str(b64encode(K_AB), 'utf-8'), Ts), 'utf-8')
    msg2 = encrypt(msg2, IVr, Kr)

    return Ns, msg1, msg2

def initial_auth():
    print('Initiating communication with B')

    try:
        data = input('> ').strip().split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(data) != 2:
        print('Invalid format')
        exit(-1)
    sender, Ns = tuple(data)

    Nb = getRandom(NONCE_SIZE)
    Tb = time.time()+5
    msg = bytes('{}||{}||{}'.format(sender, Ns, Tb), 'utf-8')
    msg = encrypt(msg, IV_B, K_BS)
    print('B -> S: {}||{}||{}'.format('B', str(b64encode(Nb), 'utf-8'), str(msg, 'utf-8')))

    Nr, msg1, msg2 = server('B', Nb, msg)
    print('Nr:', str(b64encode(Nr), 'utf-8'))
    print('msg1:', str(msg1, 'utf-8'))
    print('msg2:', str(msg2, 'utf-8'))

    try:
        data = input('> ').strip().split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(data) != 2:
        print('Invalid format')
        exit(-1)
    msg1, msg2 = tuple(data)

    try:
        msg2 = str(decrypt(msg2, IV_B, K_BS), 'utf-8').split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(msg2) != 3:
        print('Invalid format')
        exit(-1)
    user, shareKey, sessionTime = tuple(msg2)
    
    try:
        shareKey = b64decode(shareKey)
    except:
        print('Something is wrong...')
        exit(-1)

    if float(sessionTime) < time.time():
        print('Session expired!')
        exit(-1)
    if user != sender:
        print('Sender not match!')
        exit(-1)
    Nr = decrypt(msg1, IV_AB, shareKey)
    if Nr != Nb:
        print('Nonce not match!')
        exit(-1)

    flag = bytes('{}'.format(secret_msg), 'utf-8')
    flag = encrypt(flag, IV_AB, shareKey)
    print('flag:', flag)

def subsequent_auth():
    print('Continue communicating with B')

    try:
        data = input('> ').strip().split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(data) != 2:
        print('Invalid format')
        exit(-1)
    Na, msg1 = tuple(data)  
    
    try:
        msg1 = str(decrypt(msg1, IV_B, K_BS), 'utf-8').split('||')
    except:
        print('Something is wrong...')
        exit(-1)

    if len(msg1) != 3:
        print('Invalid format')
        exit(-1)
    user, shareKey, sessionTime = tuple(msg1)
    
    try:
        shareKey = b64decode(shareKey)
    except:
        print('Something is wrong...')
        exit(-1)

    if shareKey != K_AB:
        print("Don't cheat :(")
        exit(-1)

    if float(sessionTime) < time.time():
        print('Session expired!')
        exit(-1)

    Nb = getRandom(NONCE_SIZE)
    msg2 = bytes('{}'.format(Na), 'utf-8')
    msg2 = encrypt(msg2, IV_AB, shareKey)
    print('Nb:', str(b64encode(Nb), 'utf-8'))
    print('msg2:', str(msg2, 'utf-8'))

    data = input('> ').strip()
    try:
        inputNonce = decrypt(data, IV_AB, shareKey)
        inputNonce = b64decode(inputNonce)
    except:
        print('Something is wrong...')
        exit(-1)

    if inputNonce == Nb:
        print('Okay!')
        if user == 'A':
            print(secret_flag)
    else:
        print('Invalid user!')
        exit(-1)

def main():
    getKeys()

    while True:
        menu()
        choice = input('> ').strip()
        if choice == '1':
            initial_auth()
        elif choice == '2':
            subsequent_auth()
        elif choice == '3':
            break
        else:
            print('Invalid command')

if __name__ == '__main__':
    main()
