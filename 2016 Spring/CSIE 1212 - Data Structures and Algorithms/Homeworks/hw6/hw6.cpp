#include <algorithm>
#include <cmath>
#include <iostream>
#include <vector>
using namespace std;

double table[1200][120];
double p[1200];
int q[120];

double D(int i, int j) {
    if (table[i][j] > 0) return table[i][j];
    if (i == 0 && j == 0) {
        table[0][0] = abs(p[i] - q[j]);
        return table[i][j];
    }
    if (j == 0) {
        table[i][j] = abs(p[i] - q[j]) + D(i - 1, 0);
        return table[i][j];
    } else if (i == j) {
        table[i][j] = abs(p[i] - q[j]) + D(i - 1, j - 1);
        return table[i][j];
    } else {
        table[i][j] = abs(p[i] - q[j]) + min(D(i - 1, j), D(i - 1, j - 1));
        return table[i][j];
    }
    return 0;
}

int main() {
    int n, m;

    cin >> m;
    for (int i = 0; i < m; i++) cin >> p[i];

    cin >> n;
    for (int j = 0; j < n; j++) cin >> q[j];

    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++) table[i][j] = 0;

    for (int j = n - 1; j >= 0; j--) D(m - 1, j);

    int index;
    double min = table[m - 1][0];
    for (int j = 0; j < n; j++) {
        if (table[m - 1][j] < min) {
            min = table[m - 1][j];
            index = j;
        }
    }
    cout << min << endl;

    vector<int> a;
    int i = m - 1;
    int j = index;

    while (i != 0 && j != 0) {
        if (i == j) {
            a.push_back(i);
            i--;
            j--;
        } else if (table[i - 1][j - 1] <= table[i - 1][j]) {
            a.push_back(i);
            i--;
            j--;
        } else
            i--;
    }
    a.push_back(0);

    bool first = true;
    for (int index = a.size() - 1; index >= 0; index--) {
        if (!first)
            cout << " " << a[index];
        else {
            cout << a[index];
            first = false;
        }
    }
    cout << endl;

    return 0;
}