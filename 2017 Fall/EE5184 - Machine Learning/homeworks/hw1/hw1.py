import numpy as np
import pandas as pd
import math
import sys

HOUR = 9
FEA, INDEXofPM25 = 3, 1         # O3, PM2.5, SO2
O3, PM25, SO2 = 8, 10, 13       # O3, PM2.5, SO2

w = np.load('model.npy')

df = pd.read_csv(sys.argv[1], header = None, encoding = 'Big5')
df = df.drop(df.columns[[0, 1]], axis = 1)
df = np.matrix(df.values)
df[df == 'NR'] = 0.0
df = df.astype(np.float)

testX = df[[7, 9, 12], 9 - HOUR: 9].reshape(1, FEA * HOUR)
for i in range(1, 240):
    testX = np.concatenate((testX, df[[i * 18 + 7, i * 18 + 9, i * 18 + 12], 9 - HOUR: 9].reshape(1, FEA * HOUR)), axis = 0)
    
testX = np.squeeze(np.asarray(testX))                                       # Matrix to ndarray
testX = np.concatenate((testX, testX ** 2), axis = 1)                       # Add square term
testX = np.concatenate((np.ones((testX.shape[0], 1)), testX), axis = 1)     # Add bias

# Make the answer sheet
ans = np.array((['id'], ))
for i in range(0, 240):
    ans = np.concatenate((ans, np.array((['id_' + str(i)], ))), axis = 0)

right = np.concatenate((np.array((['value'], )), np.dot(testX, w)), axis = 0)
ans = pd.DataFrame(np.concatenate((ans, right), axis = 1))

ans.to_csv(sys.argv[2], header = False, index = False)