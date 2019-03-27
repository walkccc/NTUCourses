import random
import time
import base64
import secret

def main():
	random.seed(int(time.time()))
	flag = secret.FLAG
	encrypted = [ord(i) ^ random.randint(0,255) for i in flag]
	print(str(base64.b64encode(bytes(encrypted)))[2:-1])

if __name__ == "__main__":
	main()
