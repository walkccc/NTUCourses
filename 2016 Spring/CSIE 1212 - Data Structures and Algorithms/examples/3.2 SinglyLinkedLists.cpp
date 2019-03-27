#include <iostream>
using namespace std;

class StringNode {
private:
    string elem;
    StringNode* next;
    friend class StringLinkedList;
};

class StringLinkedList {
public:
    StringLinkedList();
    ~StringLinkedList();
    bool empty() const;
    const string& front() const;
    void addFront(const string& e);
    void removeFront();
    void printList();

private:
    StringNode* head;
};

StringLinkedList::StringLinkedList() : head(NULL) {}
StringLinkedList::~StringLinkedList() {
    while (!empty()) removeFront();
}
bool StringLinkedList::empty() const { return head == NULL; }
const string& StringLinkedList::front() const { return head->elem; }

void StringLinkedList::addFront(const string& e) {
    StringNode* v = new StringNode;
    v->elem = e;
    v->next = head;
    head = v;
}

void StringLinkedList::removeFront() {
    StringNode* old = head;
    head = old->next;
    delete old;
}

void StringLinkedList::printList() {
    for (StringNode* i = head; i != NULL; i = i->next) cout << i->elem << " ";
}

int main() {
    StringLinkedList* stringLinkedList = new StringLinkedList();

    int n;
    cout << "Please input n: ";
    cin >> n;

    string s;
    for (int i = 0; i < n; i++) {
        cin >> s;
        stringLinkedList->addFront(s);
    }
    stringLinkedList->printList();

    return 0;
}
