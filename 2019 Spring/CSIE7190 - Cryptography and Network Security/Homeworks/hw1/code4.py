from pwn import *
import base64


def transpose(m):

    res = [[0 for y in range(len(m))] for x in range(len(m[0]))]

    for i in range(len(m)):
        for j in range(len(m[0])):
            res[j][i] = m[i][j]

    return res


def decipher(cipherText, key):

    res = ''
    matrix = [['' for x in range(len(cipherText))] for y in range(key)]

    idx = 0
    increment = 1

    for selectedRow in range(len(matrix)):
        row = 0

        for col in range(len(matrix[row])):
            if row + increment < 0 or row + increment >= len(matrix):
                increment = increment * -1

            if row == selectedRow:
                matrix[row][col] += cipherText[idx]
                idx += 1

            row += increment

    matrix = transpose(matrix)
    for list in matrix:
        res += ''.join(list)

    return res


def getKey(c1, m1):
    allStr = []

    for numRows in range(1, len(m1)):
        direction = (numRows == 1) - 1
        rows, idx = [''] * numRows, 0
        for c in m1:
            if c == ' ':
                rows[idx] += '_'
            else:
                rows[idx] += c
            if idx == 0 or idx == numRows - 1:
                direction *= -1
            idx += direction

        myStr = ''.join(rows)
        myStr = myStr.replace('_', ' ')
        allStr.append(myStr)

    for i in range(len(allStr)):
        if c1 == allStr[i]:
            return i + 1
    return -1


def warmup(r):
    msg = str(r.recv(), encoding='utf-8')
    r.send(bytes('2\n', encoding='utf-8'))  # ANS

    print('### END of warmup\n')


def warmupAgain(r):
    for _ in range(4):
        r.recvline()

    msg = str(r.recvline(), encoding='utf-8')
    r.send(bytes(msg[11:], encoding='utf-8'))   # ANS

    print('### END of warmupAgain\n')


def preprocessing(r, words_seen):
    lines_seen = set()
    for line in open('textfiles/lines.txt', 'r'):
        if line not in lines_seen:
            lines_seen.add(line)

    for line in lines_seen:
        for word in line.split():
            s = ''
            for c in word:
                if c.isalpha():
                    s += c
            if s not in words_seen:
                words_seen.add(s)

    print('### END of preprocessing\n')

    return words_seen


def round1(r, words_seen):
    for _ in range(4):
        r.recvline()

    c1 = str(r.recvline(), encoding='utf-8')[9:]
    for i in range(26):
        sentence = ''
        for c in c1:
            if c.isalpha():
                sentence += chr((ord(c) + i) % 26 + 97)
            else:
                sentence += c
        for word in sentence.split():
            if word in words_seen:
                r.send(bytes(sentence, encoding='utf-8'))   # ANS
                break

    print('### END of round1\n')


def round2(r):
    for _ in range(6):
        r.recvline()

    c1 = str(r.recvline(), encoding='utf-8')[9:]
    m1 = str(r.recvline(), encoding='utf-8')[9:]
    c2 = str(r.recvline(), encoding='utf-8')[9:]

    # Get "salt" by c1 & m1
    salt = [0] * 7
    j = 0
    for i in range(len(c1)):
        diff = ord(c1[i]) - ord(m1[i])
        diff %= 26
        if salt[j] == 0:
            salt[j] = diff
        j = (j + 1) % 7

    # Get m2 by "salt"
    m2 = ''
    j = 0
    for c in c2:
        if c.isalpha():
            diff = ord(c) - salt[j]
            diff = diff - 97 if c.islower() else diff - 65
            diff %= 26
            diff = diff + 97 if c.islower() else diff + 65
            m2 += chr(diff)
        else:
            m2 += c
        j = (j + 1) % 7

    r.send(bytes(m2, encoding='utf-8'))

    print('### END of round2\n')


def round3(r):
    for _ in range(7):
        r.recvline()

    c1 = str(r.recvline(), encoding='utf-8')[9:-1]
    m1 = str(r.recvline(), encoding='utf-8')[9:-1]
    c2 = str(r.recvline(), encoding='utf-8')[9:-1]

    key = getKey(c1, m1)
    m2 = decipher(c2, key)

    r.send(bytes(m2 + '\n', encoding='utf-8'))

    print('### END of round3\n')


def round4(r):
    for _ in range(5):
        r.recvline()

    c1 = str(r.recvline(), encoding='utf-8')[9:-1]
    m1 = base64.b64decode(c1)

    r.send(m1)
    r.send('\n')

    print('### END of round4\n')


if __name__ == '__main__':
    r = remote('140.112.31.96', 10151)

    warmup(r)
    warmupAgain(r)
    words_seen = preprocessing(r, set())
    round1(r, words_seen)
    round2(r)
    round3(r)
    round4(r)

    r.interactive()
