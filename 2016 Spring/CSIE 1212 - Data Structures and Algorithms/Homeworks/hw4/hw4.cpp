#include <stdio.h>
#include <iostream>
#include <set>
#include <vector>
using namespace std;

struct Node {
    int bidId;
    int price;
    int clientId;
    int shareCount;
};

struct transactionList {
    int transId;
    int buyClientId;
    int sellClientId;
    int transPrice;
    int transShareCount;
};

set<int> C;

class VectorSellTree {
public:
    vector<Node> S;

public:
    typedef vector<Node>::iterator Pos;

protected:
    Pos pos(int i) { return S.begin() + i; }
    int idx(const Pos& p) const { return p - S.begin(); }

public:
    VectorSellTree() : S(1){};
    int size() const { return S.size() - 1; }
    Pos left(const Pos& s) { return pos(2 * idx(s)); }
    Pos right(const Pos& s) { return pos(2 * idx(s) + 1); }
    Pos parent(const Pos& s) { return pos(idx(s) / 2); }
    bool hasLeft(const Pos& s) const { return 2 * idx(s) <= size(); }
    bool hasRight(const Pos& s) const { return 2 * idx(s) + 1 <= size(); }
    bool isRoot(const Pos& s) const { return idx(s) == 1; }
    bool isLess(const Pos& a, const Pos& b) { return a->price < b->price; }
    Pos root() { return pos(1); }
    Pos last() { return pos(size()); }
    void addLast(const Node& s) { S.push_back(s); }
    void swap(const Pos& a, const Pos& b) {
        Node s = *a;
        *a = *b;
        *b = s;
    }
    void removeMin();
    void insert(const Node& s);
    void remove(int price);
};

void VectorSellTree::removeMin() {
    if (size() == 1)
        S.pop_back();
    else {
        Pos u = root();
        swap(u, last());
        S.pop_back();
        while (hasLeft(u)) {
            Pos v = left(u);
            if (hasRight(u) &&
                (isLess(right(u), v) ||
                 (v->price == right(u)->price && v->bidId > right(u)->bidId)))
                v = right(u);
            if (isLess(v, u) || (v->price == u->price && v->bidId < u->bidId)) {
                swap(u, v);
                u = v;
            } else
                break;
        }
    }
}

void VectorSellTree::insert(const Node& s) {
    addLast(s);
    Pos v = last();
    while (!isRoot(v)) {
        Pos u = parent(v);
        if (isLess(u, v) || (u->price == v->price && u->bidId < v->bidId))
            break;
        swap(v, u);
        v = u;
    }
}
class VectorBuyTree {
private:
    vector<Node> B;

public:
    typedef vector<Node>::iterator Pos;

protected:
    Pos pos(int i) { return B.begin() + i; }
    int idx(const Pos& p) const { return p - B.begin(); }

public:
    VectorBuyTree() : B(1){};
    int size() const { return B.size() - 1; }
    Pos left(const Pos& b) { return pos(2 * idx(b)); }
    Pos right(const Pos& b) { return pos(2 * idx(b) + 1); }
    Pos parent(const Pos& b) { return pos(idx(b) / 2); }
    bool hasLeft(const Pos& b) const { return 2 * idx(b) <= size(); }
    bool hasRight(const Pos& b) const { return 2 * idx(b) + 1 <= size(); }
    bool isRoot(const Pos& b) const { return idx(b) == 1; }
    bool isLess(const Pos& a, const Pos& b) { return a->price < b->price; }
    Pos root() { return pos(1); }
    Pos last() { return pos(size()); }
    void addLast(const Node& b) { B.push_back(b); }
    void swap(const Pos& a, const Pos& b) {
        Node s = *a;
        *a = *b;
        *b = s;
    }
    void removeMax();
    void insert(const Node& b);
    void remove(int price);
};

void VectorBuyTree::removeMax() {
    if (size() == 1)
        B.pop_back();
    else {
        Pos u = root();
        swap(u, last());
        B.pop_back();
        while (hasLeft(u)) {
            Pos v = left(u);
            if (hasRight(u) &&
                (isLess(v, right(u)) ||
                 (v->price == right(u)->price && v->bidId > right(u)->bidId)))
                v = right(u);
            if (isLess(u, v) || (v->price == u->price && v->bidId < u->bidId)) {
                swap(u, v);
                u = v;
            } else
                break;
        }
    }
}

void VectorBuyTree::insert(const Node& b) {
    addLast(b);
    Pos v = last();
    while (!isRoot(v)) {
        Pos u = parent(v);
        if (isLess(v, u) || (u->price == v->price && u->bidId < v->bidId))
            break;
        swap(u, v);
        v = u;
    }
}

int main() {
    VectorSellTree ST;
    VectorBuyTree BT;
    vector<transactionList> T;
    int transId = 0;
    int bidId, clientId, action, price, shareCount;

    while (scanf("%d%d%d%d%d", &bidId, &clientId, &action, &price,
                 &shareCount) == 5) {
        if (action == 0) {  // buy action
            if (ST.size()) {
                while (price >= ST.root()->price && ST.size() && shareCount) {
                    if (C.find(ST.root()->bidId) != C.end()) {
                        ST.removeMin();
                        continue;
                    }
                    printf("%d\t%d\t%d\t%d\t", transId, clientId,
                           ST.root()->clientId, ST.root()->price);
                    if (shareCount >= ST.root()->shareCount) {
                        shareCount -= ST.root()->shareCount;
                        printf("%d\n", ST.root()->shareCount);
                        transId++;
                        ST.removeMin();
                    } else if (shareCount < ST.root()->shareCount) {
                        ST.root()->shareCount -= shareCount;
                        printf("%d\n", shareCount);
                        shareCount = 0;
                        transId++;
                        break;
                    }
                }
            }
            if (shareCount) {
                Node b;
                b.bidId = bidId;
                b.price = price;
                b.clientId = clientId;
                b.shareCount = shareCount;
                BT.insert(b);
            }
        } else if (action == 1) {  // sell action
            if (BT.size()) {
                while (price <= BT.root()->price && BT.size() && shareCount) {
                    if (C.find(BT.root()->bidId) != C.end()) {
                        BT.removeMax();
                        continue;
                    }
                    printf("%d\t%d\t%d\t%d\t", transId, BT.root()->clientId,
                           clientId, price);
                    if (shareCount >= BT.root()->shareCount) {
                        shareCount -= BT.root()->shareCount;
                        printf("%d\n", BT.root()->shareCount);
                        transId++;
                        BT.removeMax();
                    } else if (shareCount < BT.root()->shareCount) {
                        BT.root()->shareCount -= shareCount;
                        printf("%d\n", shareCount);
                        shareCount = 0;
                        transId++;
                        break;
                    }
                }
            }
            if (shareCount) {
                Node s;
                s.bidId = bidId;
                s.price = price;
                s.clientId = clientId;
                s.shareCount = shareCount;
                ST.insert(s);
            }
        } else if (action == 2) {  // cancel action
            C.insert(price);
        }
    }

    return 0;
}