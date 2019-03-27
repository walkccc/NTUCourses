#include <bits/stdc++.h>
#define ERR 1e-10
using namespace std;

vector<double> xs;
double xl = INT_MIN, xr = INT_MAX;

struct Node {
    double max;
    double min;
};

struct Point {
    double x;
    double y;
};

class Line {
public:
    int a;
    int b;
    int c;
    double m;
    double k;
    class Line* prev;
    class Line* next;
    friend class DLinkedList;
};

class DLinkedList {
public:
    DLinkedList();                              // constructor
    ~DLinkedList();                             // destructor
    bool empty() const;                         // is list empty?
    void add(Line* v, int a, int b, int c);     // insert new line before v
    void addFront(int a, int b, int c);         // add to front of list
    void addBack(int a, int b, int c);          // add to back of list
    void remove(Line* v);                       // remove line v
    void removeFront();                         // remove from front
    void removeBack();                          // remove from back
    Line* front();                              // get front element
    Line* back();                               // get back element
    void printLine();                           // print the list
private:                                        // list sentinels
    Line* head;
    Line* tail;
};

DLinkedList::DLinkedList() {                    // constructor
    head = new Line;                            // create sentinels
    tail = new Line;
    head->next = tail;                          // have them point to each other
    tail->prev = head;
}

DLinkedList::~DLinkedList() {                   // destructor
    while (!empty()) removeFront();             // remove all but sentinels
    delete head;                                // remove the sentinels
    delete tail;
}

bool DLinkedList::empty() const { return (head->next == tail); }

void DLinkedList::add(Line* v, int a, int b, int c) {
    Line* u = new Line;
    u->a = a;
    u->b = b;
    u->c = c;
    u->m = (double) -a / b;
    u->k = (double) c / b;
    u->next = v;
    u->prev = v->prev;
    v->prev->next = u;
    v->prev = u;
}

void DLinkedList::addFront(int a, int b, int c) { add(head->next, a, b, c); }
void DLinkedList::addBack(int a, int b, int c) { add(tail, a, b, c); }

void DLinkedList::remove(Line* v) {
    Line* u = v->prev;
    Line* w = v->next;
    u->next = w;
    w->prev = u;
    delete v;
}

void DLinkedList::removeFront() { remove(head->next); }
void DLinkedList::removeBack() { remove(tail->prev); }

Line* DLinkedList::front() { return head->next; }
Line* DLinkedList::back() { return tail->prev; }

void DLinkedList::printLine() {
    Line *now = head->next;
    while (now != tail) {
        if (now->b < 0) printf("%4dx   %4dy <= %4d, m = %5.4f\n", now->a, now->b, now->c, now->m);
        if (now->b > 0) printf("%4dx + %4dy <= %4d, m = %5.4f\n", now->a, now->b, now->c, now->m);
        now = now->next;
    }
    printf("\n");
}

Point intersect(Line* p, Line* q) {
    Point point, noPoint = {INT_MIN, INT_MIN};
    double det = p->a * q->b - q->a * p->b;
    point.x = (p->c * q->b - q->c * p->b) / det;
    point.y = (p->a * q->c - q->a * p->c) / det;
    
    if (abs(det) >= ERR) return point;
    else return noPoint;
}

void prune(DLinkedList& lines, char c) {
    Line* now = lines.front();
    while (now != lines.back()->next && now->next != lines.back()->next) {
        Line* curr = now;
        if (now->next->next != lines.back()->next) now = now->next->next;
        else now = lines.back()->next;
        
        Point p = intersect(curr, curr->next);
        if (p.x != INT_MIN && p.x >= xl && p.x <= xr)
            xs.push_back(p.x);
        if (c == 'A') {
            if (abs(curr->m - curr->next->m) < ERR) {                       // Delete the line with less k (c / b)
                if (curr->k > curr->next->k) lines.remove(curr->next);
                else if (curr->k < curr->next->k) lines.remove(curr);
            } else if (p.x >= xr) {                                         // Delete the line with larger m (-a / b)
                if (curr->m < curr->next->m) lines.remove(curr->next);
                else if (curr->m > curr->next->m) lines.remove(curr);
            } else if (p.x <= xl) {                                         // Delete the line with less m (-a / b)
                if (curr->m > curr->next->m) lines.remove(curr->next);
                else if (curr->m < curr->next->m) lines.remove(curr);
            }
        } 
        else if (c == 'B') {
            if (abs(curr->m - curr->next->m) < ERR) {                       // Delete the line with larger k (c / b)
                if (curr->k < curr->next->k) lines.remove(curr->next);      
                else if (curr->k > curr->next->k) lines.remove(curr);
            } else if (p.x >= xr) {                                         // Delete the line with less m (-a / b)
                if (curr->m > curr->next->m) lines.remove(curr->next);
                else if (curr->m < curr->next->m) lines.remove(curr);
            } else if (p.x <= xl) {                                         // Delete the line with larger m (-a / b)
                if (curr->m < curr->next->m) lines.remove(curr->next);
                else if (curr->m > curr->next->m) lines.remove(curr);
            }
        }
    }
}

double assignValue(DLinkedList& lines, double xm, double val, char c) {
    Line *now = lines.front();
    double tmp = val;
    while (now != lines.back()->next) {
        double y = (now->c - now->a * xm) / now->b;
        if (y > tmp && c == 'A') tmp = y;
        if (y < tmp && c == 'B') tmp = y;
        now = now->next;
    }
    return tmp;
}

Node getSlope(DLinkedList& lines, double x, double y) {
    Node tmp = {INT_MIN, INT_MAX};
    Line *now = lines.front();
    while (now != lines.back()->next) {
        if (abs(now->a * x + now->b * y - now->c) <= ERR) {
            if (now->m > tmp.max) tmp.max = now->m;
            if (now->m < tmp.min) tmp.min = now->m;
        }
        now = now->next;
    }
    return tmp;
}

int main() {
    int n;
    scanf("%d", &n);
    DLinkedList linesA;
    DLinkedList linesB;
    
    for (int i = 0; i < n; i++) {
        int a, b, c;
        scanf("%d%d%d", &a, &b, &c);
        if (b == 0 && a > 0 && a < xr) xr = (double) c / a;
        else if (b == 0 && a < 0 && a > xl) xl = (double) c / a;
        else if (b < 0) linesA.addBack(a, b, c);
        else if (b > 0) linesB.addBack(a, b, c);
    }
    
    bool isNA = false;
    bool isINF = false;
    bool isAns = false;
    double xm;
    
    // linesA.printLine();
    // linesB.printLine();
    // int cnt = 0;
    while (true) {
        // printf("=============Round[%d]=============\n", cnt);
        
        if (xr < xl) { isNA = true; }
        if (linesA.empty()) { isINF = true; }
        
        bool isA2 = (linesA.front()->next == linesA.back());
        bool isA = (linesA.front() == linesA.back());
        bool isB = (linesB.front() == linesB.back());
        Point ans = {0.0, 0.0};
        
        if (isA && (isB || linesB.empty())) {
            Line x_l = {-1, 0, -xl};
            Line x_r = {1, 0, xr};
            Line* A = linesA.front();
            Line* B = linesB.front();
            Point p = intersect(A, B);
            
            if (A->m > 0) {
                if (linesB.empty() || (abs(A->m - B->m) < ERR) || (A->m > B->m && p.x > xl)) {
                    if ((abs(A->m - B->m) < ERR) && (A->k > B->k)) { isNA = true; }
                    else if (xl == INT_MIN) { isINF = true; }
                    else if (xl != INT_MIN) { ans = intersect(A, &x_l); isAns = true; }
                }
                else if (A->m < B->m && p.x < xl) { ans = intersect(A, &x_l); isAns = true; }
                else if (A->m < B->m && p.x > xr) { isNA = true; }
                else { ans = p; isAns = true; }
            } 
            else if (A->m < 0) {
                if (linesB.empty() || (abs(A->m - B->m) < ERR) || (A->m < B->m && p.x < xr)) {
                    if ((abs(A->m - B->m) < ERR) && (A->k > B->k)) { isNA = true; }
                    else if (xr == INT_MAX) { isINF = true; }
                    else if (xr != INT_MAX) { ans = intersect(A, &x_r); isAns = true; }
                }
                else if (A->m > B->m && p.x > xr) { ans = intersect(A, &x_r); isAns = true; }
                else if (A->m < B->m && p.x < xl) { isNA = true; }
                else { ans = p; isAns = true; }
            }
        }
        
        double ay = INT_MIN;
        double by = INT_MAX;
        Node s = {0.0, 0.0};
        Node t = {0.0, 0.0};
        
        prune(linesA, 'A');
        prune(linesB, 'B');
        
        nth_element(xs.begin(), xs.begin() + xs.size() / 2, xs.end());
        if (xs.size())
            xm = xs[xs.size() / 2];
        
        ay = assignValue(linesA, xm, ay, 'A');
        by = assignValue(linesB, xm, by, 'B');
        
        s = getSlope(linesA, xm, ay);
        t = getSlope(linesB, xm, by);
        
        if (ay <= by && s.min <= s.max && s.max < 0) { xl = xm; }
        if (ay <= by && s.max >= s.min && s.min > 0) { xr = xm; }
        if (ay <= by && s.min <= 0 && 0 <= s.max) { ans.y = ay; isAns = true; }
        if (ay > by && s.max < t.min) { xl = xm; }
        if (ay > by && s.min > t.max) { xr = xm; }
        if (ay > by && s.max >= t.min && s.min <= t.max) { isNA = true; }
        
        if (isNA) { printf("NA\n"); return 0; }
        if (isINF) { printf("-INF\n"); return 0; }
        if (isAns) { printf("%d\n", (int) round(ans.y)); return 0; }
        
        xs.clear();
        // linesA.printLine();
        // linesB.printLine();
        // cnt++;
    }
    return 0;
}
