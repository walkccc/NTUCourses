#include <bits/stdc++.h>
using namespace std;
 
struct Item {
    int value;
    int weight;
};
 
struct Node {
    int level;      
    int profit;     
    int bound;      
    int weight;   
};
 
struct cmp {
    bool operator()(Node& u, Node& v) {
        if (u.bound < v.bound) return true;
        else if (u.bound > v.bound) return false;
        else if (u.level > v.level) return true;
        else if (v.level < v.level) return false;
        return true;
    }
};
 
bool itemSort(Item a, Item b) {
    double A = (double) a.value / a.weight;
    double B = (double) b.value / b.weight;
    return A > B;
}
 
int bound(Node u, int n, int W, Item item[]) {
    if (u.weight >= W)
        return 0;
 
    int profitBound = u.profit;
    int j = u.level + 1;
    int totweight = u.weight;
 
    while ((j < n) && (totweight + item[j].weight <= W)) {
        totweight += item[j].weight;
        profitBound += item[j].value;
        j++;
    }
 
    if (j < n)
        profitBound += (W - totweight) * item[j].value / item[j].weight;
 
    return profitBound;
}
 
int knapsack(int n, int W, Item item[]) {
    priority_queue<Node, vector<Node>, cmp> PQ;
    Node u, v;
 
    PQ.empty();
    v.level = -1;
    v.profit = 0;
    v.weight = 0;
    v.bound = bound(v, n, W, item);
 
    int maxProfit = 0;
    PQ.push(v);
 
    while (!PQ.empty()) {
        u = PQ.top();
        PQ.pop();
 
        if (u.level == -1) v.level = 0;
        if (u.level == n - 1) continue;
 
        v.level = u.level + 1;
        v.weight = u.weight + item[v.level].weight;
        v.profit = u.profit + item[v.level].value;
 
        if (v.weight <= W && v.profit > maxProfit)
            maxProfit = v.profit;
 
        v.bound = bound(v, n, W, item);
 
        if (v.bound > maxProfit) PQ.push(v);
 
        v.weight = u.weight;
        v.profit = u.profit;
        v.bound = bound(v, n, W, item);
        if (v.bound > maxProfit) PQ.push(v);
    }
 
    return maxProfit;
}
 
int main() {
    int W, n;
    scanf("%d%d", &W, &n);
	
    Item item[n];
    for (int i = 0; i < n; i++)
        scanf("%d%d", &item[i].value, &item[i].weight);
    sort(item, item + n, itemSort);
 
    printf("%d", knapsack(n, W, item));
 
    return 0;
}