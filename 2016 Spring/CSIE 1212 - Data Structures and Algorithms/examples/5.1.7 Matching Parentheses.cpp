#include <iostream>
using namespace std;

class LinkedStack {
public:
    LinkedStack();
    int size() const;
    bool empty() const;
    const string& top();
    void push(const string& e);
    void pop();

private:
    SLinkedList<string> S;
    int n;
};

LinkedStack::LinkedStack() : S(), n(0) {}
int LinkedStack::size() const { return n; }
bool LinkedStack::empty() const { return n == 0; }

const string& LinkedStack::top() {
    if (empty()) return "ERROR";
    return S.front();
}

void LinkedStack::push(const string& e) {
    ++n;
    S.addFront(e);
}

void LinkedStack::pop() {
    if (empty()) return;
    --n;
    S.removeFront();
}

vector<string> getHtmlTags() {
    vector<string> tags;
    while (cin) {
        string line;
        getline(cin, line);
        int pos = 0;
        int ts = line.find("<", pos);
        while (ts != string::npos) {
            int te = line.find(">", ts + 1);
            tags.push_back(line.substr(ts, te - ts + 1));
            pos = te + 1;
            ts = line.find("<", pos);
        }
    }
    return tags;
}

bool isHtmlMatched(const vector<string>& tags) {
    LinkedStack S;
    typedef vector<string>::const_interator Iter;

    for (Iter p = tags.begin(); p != tags.end(); ++p) {
        if (p->at(1) != '/')
            S.push(*p);
        else {
            if (S.empty()) return false;
            string open = S.top().substr(1);
            string close = p->substr(2);
            if (open.compare(close) != 0)
                return false;
            else
                S.pop();
        }
    }
    if (S.empty())
        return true;
    else
        return false;
}

int main() {
    if (isHtmlMatched(getHtmlTags()))
        cout << "The input file is a matched HTML document." << endl;
    else
        cout << "The input file is not a matched HTML document." << endl;
}