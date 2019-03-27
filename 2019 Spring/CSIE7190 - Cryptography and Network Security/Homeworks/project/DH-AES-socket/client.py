from config import *

A = 19
IV_A = 23
print('G ** A % P =', str(G ** A % P))
print('G ** IV_A % P =', str(G ** IV_A % P))


def recvall(sock):
    BUFF_SIZE = 4096
    data = b''
    while True:
        part = sock.recv(BUFF_SIZE)
        data += part
        if len(part) < BUFF_SIZE:
            # either 0 or end of data
            break
    return data


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))

    while True:
        msg = input()
        s.sendall(msg.encode())
        msg = recvall(s)
        print('Message from server:\n', repr(msg))

        # client compute their SHARED_KEY by
        # g^{ab} % p = (g^b)^a % p
        if msg[0:3] == b'g^b':
            G_B = int(msg[6:].decode())
            SHARED_KEY = G_B ** A % P
            SHARED_KEY_BYTES = bytes([SHARED_KEY]) * 16
            print('SHARED_KEY:', str(SHARED_KEY))

        elif msg[0:5] == b'g^ivb':
            G_IVB = int(msg[8:].decode())
            SHARED_IV = G_IVB ** IV_A % P
            SHARED_IV_BYTES = bytes([SHARED_IV]) * 16
            print('SHARED_IV:', str(SHARED_IV))

        elif msg[0:10] == b'ciphertext':
            ciphertext = msg[13:]
            print('ciphertext:', type(ciphertext), len(ciphertext))

            with open('./ciphertext_client.txt', 'wb') as f:
                f.write(ciphertext)

            obj = AES.new(SHARED_KEY_BYTES,
                          AES.MODE_CBC, SHARED_IV_BYTES)

            model = obj.decrypt(ciphertext)

            with open('./model_client.txt', 'wb') as f:
                f.write(model)

            print('model:', type(model), len(model))
