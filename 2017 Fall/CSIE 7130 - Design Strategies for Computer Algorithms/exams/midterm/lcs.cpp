#include <bits/stdc++.h>
#define MAX 101
using namespace std;

string curStr = "";
vector<string> ans;

class LCS {
public:
    LCS();
    ~LCS();
    void buildLCS(char A[], char B[], int n, int m);
    void getLCS(int idxA, int idxB, int len, char A[], char B[], int n, int m);
    int dp[MAX][MAX];
};

LCS::LCS() {
    for (int j = 0; j < MAX; j++) dp[0][j] = 0;
    for (int i = 1; i < MAX; i++) dp[i][0] = 0;
}

LCS::~LCS() {
    for (int j = 0; j < MAX; j++) dp[0][j] = -1;
    for (int i = 1; i < MAX; i++) dp[i][0] = -1;
}

void LCS::buildLCS(char A[], char B[], int n, int m) {
    for (int i = 1; i <= n; i++) 
        for (int j = 1; j <= m; j++) {
            if (A[i - 1] == B[j - 1]) dp[i][j] = dp[i - 1][j - 1] + 1;
            else if (dp[i - 1][j] > dp[i][j - 1]) dp[i][j] = dp[i - 1][j];
            else dp[i][j] = dp[i][j - 1];
        }
}

void LCS::getLCS(int idxA, int idxB, int len, char A[], char B[], int n, int m) {
    if (len == dp[n][m]) {
        ans.push_back(curStr);
        return;
    }

    if (idxA == n || idxB == m) return;
    for (int i = idxA; i < n; i++) 
        for (int j = idxB; j < m; j++) 
            if (A[i] == B[j] && dp[i][j] == len) {
                curStr.resize(len + 1);
                curStr[len] = A[i];
                getLCS(i + 1, j + 1, len + 1, A, B, n, m);
            }
}

void printAns(int len, int size) {
    printf("%d %d\n", len, size);
    for (int i = 0; i < size; i++) 
        printf("%s\n", ans[i].c_str());
}

int main() {
    char A[MAX];
    char B[MAX];
    scanf("%s%s", A, B);
    int n = strlen(A);
    int m = strlen(B);

    LCS L;
    L.buildLCS(A, B, n, m);
    L.getLCS(0, 0, 0, A, B, n, m);
    sort(ans.begin(), ans.end());
    printAns(L.dp[n][m], ans.size());

    return 0;
}
