import numpy as np
import pandas as pd
import math
import sys

FEA = int(input('How many features: '))
if FEA == 18:
    print('Choose all 18 features.')
    INDEXofPM25 = 9
elif FEA == 3:
    print('Choose the feature of O3, PM2.5 and SO2.')
    INDEXofPM25 = 1
elif FEA == 1:
    print('Choose the feature of PM2.5 only.')
    INDEXofPM25 = 0

HOUR = int(input('How many hours: '))
MONTH = 12

O3, PM25, SO2 = 8, 10, 13       # O3, PM2.5, SO2

# Initialize learning rate, iterate times and regulation parameter
LEARNRATE = 10
iters = 100000
LAMBDA = float(input('Whats the regulation parameter: '))

df = pd.read_csv('data/train.csv', header = None, encoding = 'Big5')
df = df.drop(df.index[0])
df = df.drop(df.columns[[0, 1, 2]], axis = 1)    

if FEA == 3:
    for i in range(18):
        if i == O3 or i == PM25 or i == SO2:
            continue
        df = df.drop(df.index[df.index % 18 == i])

if FEA == 1:
    for i in range(18):
        if i == PM25:
            continue
        df = df.drop(df.index[df.index % 18 == i])

df = np.matrix(df.values)
df[df == 'NR'] = 0

# Initialize 1/1 (train.csv)
data = df[0: FEA, :]
for i in range(1, MONTH * 20):
    data = np.concatenate((data, df[i * FEA:i * FEA + FEA, :]), axis = 1)

def assignValue(hour, INDEXofPM25):
    X = np.zeros(((480 - hour) * MONTH, hour * FEA))
    y = np.zeros(((480 - hour) * MONTH, 1))
    j = 0      
    for i in range(data.shape[1]):
        if i % 480 > 480 - hour - 1:
            continue
        X[j] = data[: , i: i + hour].reshape(1, FEA * hour)
        y[j] = data[INDEXofPM25, i + hour]
        j = j + 1
    return X, y

X, y = assignValue(HOUR, INDEXofPM25)

X = np.concatenate((X, X ** 2), axis = 1)                       # Add square term
X = np.concatenate((np.ones((X.shape[0], 1)), X), axis = 1)     # Add bias

w = np.zeros((X.shape[1], 1))       # Initialize weight
Sgra = np.zeros((X.shape[1], 1))    # Initialize Sgra

# Train the model
for i in range(iters):
    loss = np.dot(X, w) - y 
    cost = (np.sum(loss ** 2) + LAMBDA * np.sum(w ** 2)) / X.shape[0]
    costA  = math.sqrt(cost)
    gra = np.dot(X.T, loss)
    Sgra += gra ** 2
    ada = np.sqrt(Sgra)
    w = w - LEARNRATE * gra / ada
    print ('iteration: %d | Cost: %f  ' % (i, costA))

np.save('model.npy', w)
w = np.load('model.npy')

df = pd.read_csv('data/test.csv', header = None, encoding = 'Big5')
df = df.drop(df.columns[[0, 1]], axis = 1)
df = np.matrix(df.values)
df[df == 'NR'] = 0.0
df = df.astype(np.float)

if FEA == 18:    
    testX = df[0: 18, 9 - HOUR: 9].reshape(1, FEA * HOUR)
    for i in range(1, 240):
        testX = np.concatenate((testX, df[i * FEA:i * FEA + FEA, 9 - HOUR: 9].reshape(1, FEA * HOUR)), axis = 0)
elif FEA == 3:
    testX = df[[O3 - 1, PM25 - 1, SO2 - 1], 9 - HOUR: 9].reshape(1, FEA * HOUR)
    for i in range(1, 240):
        testX = np.concatenate((testX, df[[i * 18 + O3 - 1, i * 18 + PM25 - 1, i * 18 + SO2 - 1], 9 - HOUR: 9].reshape(1, FEA * HOUR)), axis = 0)
elif FEA == 1:
    testX = df[[PM25 - 1], 9 - HOUR: 9].reshape(1, FEA * HOUR)
    for i in range(1, 240):
        testX = np.concatenate((testX, df[[i * 18 + PM25 - 1], 9 - HOUR: 9].reshape(1, FEA * HOUR)), axis = 0)

testX = np.squeeze(np.asarray(testX))                                       # Matrix to ndarray
testX = np.concatenate((testX, testX ** 2), axis = 1)                       # Add square term
testX = np.concatenate((np.ones((testX.shape[0], 1)), testX), axis = 1)     # Add bias

# Make the answer sheet
ans = np.array((['id'], ))
for i in range(0, 240):
    ans = np.concatenate((ans, np.array((['id_' + str(i)], ))), axis = 0)

right = np.concatenate((np.array((['value'], )), np.dot(testX, w)), axis = 0)
ans = pd.DataFrame(np.concatenate((ans, right), axis = 1))

ans.to_csv('result/res.csv', header = False, index = False)