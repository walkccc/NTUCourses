import sys
import numpy as np
import pandas as pd

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def readFile(filename):
    return pd.read_csv(filename).as_matrix().astype('float')

def cost(X, y, theta):
    p = sigmoid(np.dot(X, theta))
    return -np.mean(y * np.log(p + 1e-20) + (1 - y) * np.log((1 - p + 1e-20)))

def scale(X, mean, std):
    return (X - mean) / (std + 1e-20)

def evaluate(X, y, theta):
    p = sigmoid(np.dot(X, theta))
    p[p < 0.5] = 0.0
    p[p >= 0.5] = 1.0
    return np.mean(1 - np.abs(y - p))

def regression(X_train, Y_train, LR, iters):
    X_train = scale(X_train, meanX, stdX)                                               # Normalize
    X_train = np.concatenate((np.ones((X_train.shape[0], 1)), X_train), axis = 1)       # Add bias

    theta = np.zeros((X_train.shape[1], 1))                                             # Init theta(w)

    initLR = LR                                                                         # Save the original LearnRate 
    thetaLR = 0.0
    for i in range(iters):
        grad = -np.dot(X_train.T, (Y_train - sigmoid(np.dot(X_train, theta))))          # Calculate the gradient
        thetaLR = thetaLR + grad ** 2
        LR = initLR / np.sqrt(thetaLR)
        theta -= LR * grad                                                              # Update theta(w)

        if i % 100 == 99:
            print('[Iters {:5d}] - training cost: {:.5f}, accuracy: {:.5f}'.format(i + 1, cost(X_train, Y_train, theta), evaluate(X_train, Y_train, theta)))
    return theta

def regulate(X, I):
    return np.concatenate((X, X[:, I] ** 2, X[:, I] ** 3, X[:, I] ** 4, X[:, I] ** 5, np.log(X[:, I] + 1e-10), (X[:, 0] * X[:, 3]).reshape(X.shape[0], 1), (X[:, 0] * X[:, 5]).reshape(X.shape[0], 1), (X[:, 0] * X[:, 5]).reshape(X.shape[0], 1) ** 2, (X[:, 3] * X[:, 5]).reshape(X.shape[0], 1), X[:, 6:] * X[:, 5].reshape(X.shape[0], 1), (X[:, 3] - X[:, 4]).reshape(X.shape[0], 1), (X[:, 3] - X[:, 4]).reshape(X.shape[0], 1) ** 3), axis = 1)

X, Y, X_test = readFile(sys.argv[3]), readFile(sys.argv[4]), readFile(sys.argv[5])
# X, X_test = regulate(X, [0, 1, 3, 4, 5]), regulate(X_test, [0, 1, 3, 4, 5])

X_train, Y_train = X, Y
meanX, stdX = np.mean(X_train, axis = 0), np.std(X_train, axis = 0)

theta = regression(X_train, Y_train, 0.05, 3000)

with open(sys.argv[6], 'w') as fout:
    print('id,label', file = fout)
    X_test = scale(X_test, meanX, stdX)                                                   # Normalize
    X_test = np.concatenate((np.ones((X_test.shape[0], 1)), X_test), axis = 1)            # Add bias
    pred = sigmoid(np.dot(X_test, theta))
    for (i, v) in enumerate(pred.flatten()):
        print('{},{}'.format(i + 1, 1 if v >= 0.5 else 0), file = fout)