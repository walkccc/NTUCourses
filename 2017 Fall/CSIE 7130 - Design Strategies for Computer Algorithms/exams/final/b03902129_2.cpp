#include <bits/stdc++.h>
#define MAXN 200000
using namespace std;

struct Point {
    long long x;
    long long y;
    int no;
};
Point point[MAXN];

struct Ans {
    int idx1;
    int idx2;
    long long min;
};
vector<Ans> ans;

int cmp(const void* a, const void* b) {
    Point* p1 = (Point*) a;
    Point* p2 = (Point*) b;
    if (p1->x < p2->x) return -1;
    else if (p1->x > p2->x) return 1;
    else if (p1->y < p2->y) return -1;
    else if (p1->y > p2->y) return 1;
    return 0;
}

long long dist(Point a, Point b) { return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y); }
long long min(long long x, long long y) { return x < y ? x : y; }

long long MergePair(int l, int m, int r, long long dis) {
    int midLine = point[m].x;
    for (int i = m; i >= l; i--) {
        if ((point[i].x - midLine) * (point[i].x - midLine) > dis) break;
        for (int j = m + 1; j <= r; j++) {
            long long xSquare = (point[i].x - point[j].x) * (point[i].x - point[j].x);
            if (xSquare > dis) break;
            long long tmpDist = xSquare + (point[i].y - point[j].y) * (point[i].y - point[j].y);
            if (tmpDist < dis) {
                ans.clear();
                dis = tmpDist;
                Ans a;
                if (point[i].no < point[j].no) {
                     a.idx1 = point[i].no;
                     a.idx2 = point[j].no;
                     a.min = tmpDist;
                } else {
                    a.idx1 = point[j].no;
                    a.idx2 = point[i].no;
                    a.min = tmpDist;
                }  
                ans.push_back(a);
            } else if (tmpDist == dis) {
                Ans a;
                if (point[i].no < point[j].no) {
                     a.idx1 = point[i].no;
                     a.idx2 = point[j].no;
                     a.min = tmpDist;
                } else {
                    a.idx1 = point[j].no;
                    a.idx2 = point[i].no;
                    a.min = tmpDist;
                }  
                ans.push_back(a);
            } 
        }
    }
    return dis;
}

long long ClosestPair(int l, int r, long long* dis) {
    if (l < r) {
        if (l == r - 1) {
            long long tmpDist = dist(point[l], point[r]);
            if (tmpDist < *dis) {
                ans.clear();
                Ans a;
                if (point[l].no < point[r].no) {
                    a.idx1 = point[l].no;
                    a.idx2 = point[r].no;
                    a.min = tmpDist;
                } else {
                    a.idx1 = point[r].no;
                    a.idx2 = point[l].no;
                    a.min = tmpDist;
                }  
                ans.push_back(a);
                return tmpDist;
            } else if (tmpDist == *dis) {
                Ans a;
                if (point[l].no < point[r].no) {
                    a.idx1 = point[l].no;
                    a.idx2 = point[r].no;
                    a.min = tmpDist;
                } else {
                    a.idx1 = point[r].no;
                    a.idx2 = point[l].no;
                    a.min = tmpDist;
                }  
                ans.push_back(a);
                return tmpDist;
            }
        }
        int m = (l + r) >> 1;
        *dis = min(*dis, ClosestPair(l, m, dis));
        *dis = min(*dis, ClosestPair(m + 1, r, dis));
        *dis = min(*dis, MergePair(l, m, r, *dis));

        return *dis;
    }
    return LLONG_MAX;
}

int cmpAns(const Ans &a, const Ans &b) {
    if (a.idx1 != b.idx1) return (a.idx1 < b.idx1);
    return (a.idx2 < b.idx2);
}

int main() {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
        scanf("%lld%lld", &point[i].x, &point[i].y);
        point[i].no = i + 1;
    }
    qsort(point, n, sizeof(Point), cmp);

    long long distance = LLONG_MAX;

    distance = ClosestPair(0, n - 1, &distance);
    sort(ans.begin(), ans.end(), cmpAns);
    // printf("%lld %lu\n", distance, ans.size());
    printf("%.2f %lu\n", sqrt(distance), ans.size());       // Judge Girl
    for (int i = 0; i < ans.size(); i++) 
        printf("%d %d\n", ans[i].idx1, ans[i].idx2);

    return 0;
}