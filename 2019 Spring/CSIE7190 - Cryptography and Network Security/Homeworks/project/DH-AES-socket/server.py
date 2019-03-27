from config import *

FILE_NAME = 'net.pkl'
B = 17
IV_B = 47

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()

    with conn:
        print('Connected by', addr)
        while True:
            msg = conn.recv(1024)
            print('Message from client:\n', repr(msg))

            if msg[0:3] == b'g^a':
                conn.sendall(b'g^b = ' + str(G ** B % P).encode())
                G_A = int(msg[6:].decode())
                SHARED_KEY = G_A ** B % P
                SHARED_KEY_BYTES = bytes([SHARED_KEY]) * 16
                print('SHARED_KEY:', str(SHARED_KEY))

            elif msg[0:5] == b'g^iva':
                conn.sendall(b'g^ivb = ' + str(G ** IV_B % P).encode())
                G_IVA = int(msg[8:].decode())
                SHARED_IV = G_IVA ** IV_B % P
                SHARED_IV_BYTES = bytes([SHARED_IV]) * 16
                print('SHARED_IV:', str(SHARED_IV))

            elif msg == b'MODEL':
                with open('net.pkl', 'rb') as file:
                    FILE_SIZE = os.path.getsize(FILE_NAME)
                    LEN_PAD = 16 - FILE_SIZE % 16
                    model = file.read()
                    model = model + b' ' * LEN_PAD
                    print('model:', type(model), len(model))

                    with open('./model_server.txt', 'wb') as f:
                        f.write(model)

                    obj = AES.new(SHARED_KEY_BYTES,
                                  AES.MODE_CBC, SHARED_IV_BYTES)
                    ciphertext = obj.encrypt(model)

                    with open('./ciphertext_server.txt', 'wb') as f:
                        f.write(ciphertext)

                    print('ciphertext:', type(ciphertext), len(ciphertext))

                    conn.sendall(b'ciphertext = ' + ciphertext)

            elif msg == b'q':
                s.close()

            # conn.sendall(msg)
