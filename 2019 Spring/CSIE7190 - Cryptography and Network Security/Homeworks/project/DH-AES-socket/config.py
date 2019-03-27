import os
import socket
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from base64 import b64encode

HOST = '127.0.0.1'
PORT = 3212
P = 367
G = 5
