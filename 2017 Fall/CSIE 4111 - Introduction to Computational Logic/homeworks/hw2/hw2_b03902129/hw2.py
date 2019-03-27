# Introduction tO Computational Logic Homework 2
# Due Date: October 25, 2017
# B03902129 資工四 陳鵬宇

n, m = map(int, input('Please enter the number of pigeons and holes: ').split())

with open('output.txt', 'w') as f:
    print('c This is an example of SAT formula', file = f)
    print('p cnf ' + str(n * m) + ' ' + str((int)(n + (n * (n - 1) * m) / 2)), file = f)
    for i in range(n):
        for j in range(m):
            print(str(i * m + j + 1), end = ' ', file = f)
            if j == m - 1:
                print('0', file = f)

    for i in range(n):
        for j in range(i + 1, n):
            for k in range(m):
                print('-' + str(i * m + k + 1) + ' ' + '-' + str(j * m + k + 1) + ' 0', file = f)