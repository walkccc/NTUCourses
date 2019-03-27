from pwn import *
import os
import sys
import base64
import random
import hashlib
from hashpumpy import hashpump

# nc 140.112.31.96 10154


def flagMarket(r):
    r.recv()

    # 2. Buy BALSN coin
    #   Q: How many BALSN coin you want?
    #   A: 1

    r.send('2\n')
    r.send('1\n')

    isGetToken = False
    while not isGetToken:
        msg = r.recvline()
        if 'Token:' in msg:
            token = msg[7:-1]
            isGetToken = True
            break

    # print('token =', token)

    for key_len in range(40, 55):

        # Usage:
        #
        #   hashpump(hexdigest, original_data, data_to_add, key_length)
        #           -> (digest, message)
        #
        #   Arguments:
        #       hexdigest(str):      Hex-encoded result of hashing key + original_data.
        #       original_data(str):  Known data used to get the hash result hexdigest.
        #       data_to_add(str):    Data to append
        #       key_length(int):     Length of unknown data prepended to the hash
        #
        #   Returns:
        #       A tuple containing the new hex digest and the new message.
        #
        #
        # In this problem:
        #
        #   Arguments:
        #       hexdigest(str):     sha256('key={KEY}&BALSN_Coin=1')
        #       original_data(str): '&BALSN_Coin=1'
        #       data_to_add(str):   '&BALSN_Coin=1001'
        #       key_length(int):    len(KEY) + 4

        digest, message = hashpump(
            token,
            '&BALSN_Coin=1',
            '&BALSN_Coin=2147483648&hidden_flag={0.__ne__.__doc__[18]}{0.__init__.__doc__[29]}{0.rjust.__doc__[92]}{0.__mod__.__doc__[19]}{0.format.__doc__[9]}',
            key_len)

        # 3. Buy Flag
        #   Q: How many BALSN coin you have? (input encode in base64)
        #   A: base64.b64encode('1\x80\x00\x00...&BALSN_Coin=1001')
        #   Q: Show me your token.
        #   A: digest from hashpump

        # print(digest)
        # print(message)

        r.send('3\n')
        r.send(base64.b64encode(message[12:]))
        r.send('\n')
        r.send(digest)
        r.send('\n')

        msg = r.recv()
        if 'Here is your flag' in msg:
            print(msg)
            return True


if __name__ == "__main__":
    isGetFlag = False
    while not isGetFlag:
        r = remote('140.112.31.96', 10154)
        isGetFlag = flagMarket(r)
