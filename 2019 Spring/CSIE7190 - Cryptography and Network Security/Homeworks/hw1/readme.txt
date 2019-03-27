4. Babe crypto
$ python3 code4.py
(1) 執行後就可以看到 FLAG
(2) 此題運用事先跟 server 要的 textfiles/lines.txt 來做預處理

5. OTP
$ python3 code5.py
(1) 執行後就可以看到 (1)、(2) 兩小題的 FLAG
(2) 第 1 小題有時會因時間差沒噴出正確 FLAG，通常再連幾次就有了。
(3) 第 2 小題事先跟 server 要了 200 組 ciphers 並存成 keysCiphers.npy 的格式來做讀取。

6. MD5 Collision
$ python3 code6.py
(1) 執行後就可看到 FLAG
(2) 此題使用工具 python-md5-collision 來生成兩份 python 2 code，再手動 encode 成 base64 格式

7. Flag Market
$ python2 code7.py
(0) 就只有這題用 python2
(1) 執行後就可看到 FLAG 和 HIDDEN FLAG
(2) 此題使用工具 HashPump 來取得 message 和 digest

8. RSA
$ python3 code8.py
執行後就可看到 FLAG

9. The Backdoor of Diffie-Hellman
$ python3 code9.py
執行後就可看到 FLAG
