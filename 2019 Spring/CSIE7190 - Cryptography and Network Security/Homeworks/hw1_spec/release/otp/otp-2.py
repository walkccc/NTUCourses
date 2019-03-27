import random
import time
import base64
import secret


def gen_keys():
    random.seed(secret.SEED)
    keys = []
    for i in range(64):
        keys += [[random.randint(0, 255) for i in range(48)]]
    return keys


def encrypt(text, key):
    return [text[i] ^ key[i] for i in range(48)]


def main():
    keys = gen_keys()
    random.seed(int(time.time()))
    key_index = random.randint(0, (2**64)-1)
    flag = secret.FLAG
    encrypted = [ord(c) for c in flag]
    for i in range(64):
        if key_index & (2**i) != 0:
            encrypted = encrypt(encrypted, keys[i])
    print(str(base64.b64encode(bytes(encrypted)))[2:-1])


if __name__ == "__main__":
    main()
