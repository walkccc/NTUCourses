#include <stdio.h>
#include <cstring>
#include <iostream>
#include <stack>
using namespace std;

#define ROW (idx < m)
#define COL (idx >= m)

stack<int*> myStack;
class Nonogram {
public:
    Nonogram(int a, int b);
    void readData(int m, int n);
    void InitialHeuristicSearch(int m, int n);
    void dfs(int x);
    void getPermNum(int m);
    void find();
    bool check(int row);
    int sumOfData(int* a, int runs);
    void initBase(int idx);
    void perm(int n, int k, int zeros, int size, int idx);
    void cmp(int* a, int* b, int idx);
    void cmp2(int* a, int* b, int idx);
    void cmp3(int* a, int* b, int idx);
    void cmp4(int* a, int* b, int idx);
    int* trans(int* datas, int* zeros, int runs, int idx);
    int* trans2(int* a, int idx);
    void paint(int idx);
    bool* newBool(int* a, int* b, int idx);
    int* rowMaze(int** maze, int idx);
    void printMaze();
    void initMap();

public:
    int** data;
    int zeros;
    int* runs;
    int* blank;

    int* tmp;
    int* childTmp;
    int* firstTmp;
    int* secTmp;
    int* newTmp;
    int* realTmp;
    int* dfsTmp;
    int* realDfsTmp;

    bool* base;
    bool* tryBase;
    bool* secBase;
    bool* newBase;
    bool* realBase;

    bool first;
    bool correct;
    bool newFirst;
    bool isChange;
    bool afterFirstRound;
    bool dfsFlag = false;
    bool getNum = false;
    bool findNew;
    bool dfsCorrect = false;

    int* permNum;
    int** map;
    int** maze;
    int m;
    int n;
};

Nonogram::Nonogram(int a, int b) {
    m = a;
    n = b;
    maze = new int*[m];
    for (int i = 0; i < m; i++) maze[i] = new int[n];
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) maze[i][j] = -1;
}

int Nonogram::sumOfData(int* a, int runs) {
    int sum = 0;
    for (int i = 0; i < runs; i++) sum += a[i];
    return sum;
}

int* Nonogram::rowMaze(int** maze, int idx) {
    int* rowmaze = new int[m];
    for (int i = 0; i < m; i++) rowmaze[i] = maze[i][idx - m];
    return rowmaze;
}

void Nonogram::perm(int s, int k, int zeros, int size, int idx) {
    if (k == 0) {
        blank[0] = s;
        for (int i = 0; i < size; i++) zeros -= blank[i];
        if (zeros == 0) {
            if (getNum)
                cmp4(maze[idx], trans(data[idx], blank, runs[idx], idx), idx);
            else if (dfsFlag)
                cmp3(maze[idx], trans(data[idx], blank, runs[idx], idx), idx);
            else if (afterFirstRound) {
                if
                    ROW {
                        if (newFirst)
                            cmp2(maze[idx],
                                 trans(data[idx], blank, runs[idx], idx), idx);
                        else
                            cmp2(realTmp,
                                 trans(data[idx], blank, runs[idx], idx), idx);
                    }
                else if
                    COL {
                        if (newFirst)
                            cmp2(rowMaze(maze, idx),
                                 trans(data[idx], blank, runs[idx], idx), idx);
                        else
                            cmp2(realTmp,
                                 trans(data[idx], blank, runs[idx], idx), idx);
                    }
            } else {
                if (first) {
                    first = false;
                    int t = ROW ? n : m;
                    childTmp = new int[t];
                    firstTmp = new int[t];
                    childTmp = trans(data[idx], blank, runs[idx], idx);
                    for (int i = 0; i < t; i++) firstTmp[i] = childTmp[i];
                    cmp(firstTmp, trans(data[idx], blank, runs[idx], idx), idx);
                } else
                    cmp(firstTmp, trans(data[idx], blank, runs[idx], idx), idx);
            }
        }
    } else {
        for (int i = 0; i <= s; i++) {
            blank[k] = i;
            perm(s - i, k - 1, zeros, size, idx);
        }
    }
}

void Nonogram::cmp(int* a, int* b, int idx) {
    int t = ROW ? n : m;
    for (int i = 0; i < t; i++) {
        if (!base[i])
            continue;
        else if (a[i] == b[i] && base[i] == true)
            continue;
        else
            base[i] = false;
    }
}

void Nonogram::cmp2(int* a, int* b, int idx) {
    int t = ROW ? n : m;
    newBase = new bool[t];
    secBase = new bool[t];
    newTmp = new int[t];
    if (newFirst) {
        correct = true;
        for (int i = 0; i < t; i++)
            if (a[i] != -1)
                if (a[i] != b[i]) correct = false;
        if (correct) {
            newFirst = false;
            newBase = newBool(a, b, idx);
            newTmp = trans2(b, idx);
        }

        realTmp = new int[t];
        for (int i = 0; i < t; i++) realTmp[i] = newTmp[i];

        realBase = new bool[t];
        for (int i = 0; i < t; i++) realBase[i] = newBase[i];
    } else {
        if
            ROW secBase = newBool(maze[idx], b, idx);
        else if
            COL secBase = newBool(rowMaze(maze, idx), b, idx);
        bool allSame = true;
        for (int i = 0; i < t; i++)
            if (secBase[i] != realBase[i]) {
                allSame = false;
                break;
            }
        if (allSame) {
            for (int i = 0; i < t; i++) {
                if (a[i] == b[i] && base[i] == true)
                    base[i] = true;
                else
                    base[i] = false;
            }
        }
    }
}

void Nonogram::cmp3(int* a, int* b, int idx) {
    for (int i = 0; i < n; i++)
        if (a[i] != -1 && a[i] != b[i]) return;
    myStack.push(b);
}

void Nonogram::cmp4(int* a, int* b, int idx) {
    for (int i = 0; i < n; i++)
        if (a[i] != -1 && a[i] != b[i]) return;
    permNum[idx]++;
}

int* Nonogram::trans(int* datas, int* zeros, int runs, int idx) {
    int t = ROW ? n : m;
    tmp = new int[t];

    int i = 0;
    for (int cnt = zeros[0]; cnt > 0; cnt--, i++) tmp[i] = 0;

    for (int j = 0; j < runs; j++) {
        for (int x = datas[j]; x > 0; x--, i++) tmp[i] = 1;
        if (j < runs - 1) {
            tmp[i] = 0;
            i++;
        }
        for (int y = zeros[j + 1]; y > 0; y--, i++) tmp[i] = 0;
    }
    return tmp;
}

int* Nonogram::trans2(int* a, int idx) {
    int t = ROW ? n : m;
    secTmp = new int[t];
    for (int i = 0; i < t; i++) secTmp[i] = a[i];
    return secTmp;
}

void Nonogram::initBase(int t) {
    base = new bool[t];
    for (int i = 0; i < t; i++) base[i] = true;
}

bool* Nonogram::newBool(int* a, int* b, int idx) {
    int t = ROW ? n : m;
    tryBase = new bool[t];
    for (int i = 0; i < t; i++) tryBase[i] = false;
    for (int i = 0; i < t; i++) {
        if (a[i] == b[i])
            tryBase[i] = true;
        else
            tryBase[i] = false;
    }
    return tryBase;
}

void Nonogram::paint(int idx) {
    int t = ROW ? n : m;
    for (int i = 0; i < t; i++) {
        if (base[i]) {
            if (afterFirstRound) {
                if
                    ROW {
                        if (maze[idx][i] == -1) {
                            isChange = true;
                            if (realTmp[i] == 1)
                                maze[idx][i] = 1;
                            else if (realTmp[i] == 0)
                                maze[idx][i] = 0;
                        }
                    }
                else if
                    COL {
                        if (maze[i][idx - m] == -1) {
                            isChange = true;
                            if (realTmp[i] == 1)
                                maze[i][idx - m] = 1;
                            else if (realTmp[i] == 0)
                                maze[i][idx - m] = 0;
                        }
                    }
            } else {
                if
                    ROW {
                        if (maze[idx][i] == -1) {
                            isChange = true;
                            if (firstTmp[i] == 1)
                                maze[idx][i] = 1;
                            else if (firstTmp[i] == 0)
                                maze[idx][i] = 0;
                        }
                    }
                else if
                    COL {
                        if (maze[i][idx - m] == -1) {
                            isChange = true;
                            if (firstTmp[i] == 1)
                                maze[i][idx - m] = 1;
                            else if (firstTmp[i] == 0)
                                maze[i][idx - m] = 0;
                        }
                    }
            }
        }
    }
}

void Nonogram::printMaze() {
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (map[i][j] == -1)
                cout << '?';
            else if (map[i][j] == 0)
                cout << '.';
            else if (map[i][j] == 1)
                cout << '#';
        }
        cout << endl;
    }
}

void Nonogram::readData(int m, int n) {
    for (int i = 0; i < m + n; i++) runs[i] = 0;

    string buf;
    for (int i = 0; i < m + n; i++) {
        getline(cin, buf);
        data[i] = new int[buf.size()];
        int j = 0;
        int tmp = -1;
        for (int bufPos = 0; bufPos < buf.size(); bufPos++)
            if (buf[bufPos] == ' ') {
                if (bufPos - tmp == 2)
                    data[i][j] = buf[bufPos - 1] - '0';
                else if (bufPos - tmp == 3)
                    data[i][j] =
                        10 * (buf[bufPos - 2] - '0') + buf[bufPos - 1] - '0';
                runs[i]++;
                j++;
                tmp = bufPos;
            }
        if (buf.size() - tmp == 2)
            data[i][j] = buf[buf.size() - 1] - '0';
        else if (buf.size() - tmp == 3)
            data[i][j] =
                10 * (buf[buf.size() - 2] - '0') + buf[buf.size() - 1] - '0';
        runs[i]++;
    }
}

void Nonogram::InitialHeuristicSearch(int m, int n) {
    afterFirstRound = false;
    isChange = true;
    while (isChange) {
        isChange = false;
        for (int i = 0; i < m + n; i++) {
            int t = (i < m) ? n : m;
            int spaces = runs[i] + 1;
            zeros = t - (sumOfData(data[i], runs[i]) + (runs[i] - 1));
            blank = new int[spaces];
            tmp = new int[t];
            initBase(t);
            first = true;
            newFirst = true;
            findNew = false;
            perm(zeros, spaces, zeros, spaces, i);
            paint(i);
        }
        afterFirstRound = true;
    }
}

void Nonogram::initMap() {
    map = new int*[m];
    for (int i = 0; i < m; i++) map[i] = new int[n];
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) map[i][j] = maze[i][j];
}

void Nonogram::dfs(int row) {
    if (row == m || dfsCorrect) return;
    zeros = n - (sumOfData(data[row], runs[row]) + (runs[row] - 1));
    perm(zeros, runs[row] + 1, zeros, runs[row] + 1, row);
    for (int i = 0; i < permNum[row] && !dfsCorrect; i++) {
        for (int j = 0; j < n; j++) map[row][j] = myStack.top()[j];
        myStack.pop();
        if (check(row)) dfs(row + 1);
    }
}

bool Nonogram::check(int row) {
    // cout << "row = " << row << endl;
    // printMaze();
    // cout << endl;
    for (int i = 0; i < n; i++) {  // check col by col
        int k = 0;
        for (int j = 0; j <= row; j++) {
            if (maze[j][i] == 1) {
                int cnt = data[i + m][k];
                for (; j <= row && cnt; j++) {
                    if (maze[j][i] == 1) {
                        //                        cout << "maze[" << j << "]["
                        //                        << i << "] = " << maze[j][i]
                        //                        << endl;
                        cnt--;
                        //                        cout << "cnt = " << cnt <<
                        //                        endl; cout << "j = " << j <<
                        //                        endl;
                    }
                    if (cnt && maze[j][i] == 0) {
                        //                        cout << "393\n";
                        //                        cout << "cnt = " << cnt <<
                        //                        endl; cout << "maze[" << j <<
                        //                        "][" << i << "] = " <<
                        //                        maze[j][i] << endl;
                        return false;
                    }
                }
                if (cnt && maze[j][i] == 0) {
                    // cout << "393\n";
                    // cout << "cnt = " << cnt << endl;
                    // cout << "maze[" << j << "][" << i << "] = " << maze[j][i]
                    // << endl;
                    return false;
                }
                if (j <= row) {
                    if (maze[j][i] == 1) {
                        // cout << "m = " << m << endl;
                        // cout << "maze[" << j << "][" << i << "] = " <<
                        // maze[j][i] << endl;
                        return false;
                    }
                }
                k++;
            }
        }
    }
    return true;
}
void Nonogram::getPermNum(int m) {
    permNum = new int[m];
    for (int i = 0; i < m; i++) {
        zeros = n - (sumOfData(data[i], runs[i]) + (runs[i] - 1));
        perm(zeros, runs[i] + 1, zeros, runs[i] + 1, i);
    }
}

int main() {
    int m, n;
    cin >> m >> n;
    getchar();

    Nonogram* nono = new Nonogram(m, n);
    nono->data = new int*[m + n];
    nono->runs = new int[m + n];
    nono->readData(m, n);
    nono->InitialHeuristicSearch(m, n);
    nono->getNum = true;
    nono->getPermNum(m);
    nono->getNum = false;
    nono->initMap();
    nono->dfsFlag = true;
    nono->dfs(0);
    nono->printMaze();

    return 0;
}