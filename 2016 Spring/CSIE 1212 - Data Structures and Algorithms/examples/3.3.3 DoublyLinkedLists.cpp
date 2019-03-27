#include <iostream>
#include <string>
using namespace std;

typedef string Elem;
class DNode {
private:
    Elem elem;
    DNode* prev;
    DNode* next;
    friend class DLinkedList;
};

class DLinkedList {
public:
    DLinkedList();
    ~DLinkedList();
    bool empty() const;
    const Elem& getFront() const;
    const Elem& getBack() const;
    void addFront(const Elem& e);
    void addBack(const Elem& e);
    void removeFront();
    void removeBack();
    void printList();
    // private:
    DNode* getNode(const Elem& e);
    DNode* header;
    DNode* trailer;
    // protected:
    void add(DNode* v, const Elem& e);
    void remove(DNode* v);
};

DLinkedList::DLinkedList() {
    header = new DNode;
    trailer = new DNode;
    header->next = trailer;
    trailer->prev = header;
}

DLinkedList::~DLinkedList() {
    while (!empty()) removeFront();
    delete header;
    delete trailer;
}

bool DLinkedList::empty() const { return header->next == trailer; }
const Elem& DLinkedList::getFront() const { return header->next->elem; }
const Elem& DLinkedList::getBack() const { return trailer->prev->elem; }

void DLinkedList::add(DNode* v, const Elem& e) {
    DNode* u = new DNode;
    u->elem = e;
    u->next = v;
    u->prev = v->prev;
    v->prev->next = u;
    v->prev = u;  // "=?" v->prev->next = v->prev = u;
}

void DLinkedList::addFront(const Elem& e) { add(header->next, e); }
void DLinkedList::addBack(const Elem& e) { add(trailer, e); }

void DLinkedList::remove(DNode* v) {
    DNode* u = v->prev;
    DNode* w = v->next;
    u->next = w;
    w->prev = u;
    delete v;
}

void DLinkedList::removeFront() { remove(header->next); }
void DLinkedList::removeBack() { remove(trailer->prev); }

DNode* DLinkedList::getNode(const Elem& e) {
    for (DNode* i = header->next; i != trailer; i = i->next)
        if (!i->elem.compare(e)) return i;
    return header;
}

void DLinkedList::printList() {
    for (DNode* i = header->next; i != trailer; i = i->next)
        cout << i->elem << " ";
}

int main() {
    DLinkedList* dLinkedList = new DLinkedList();
    int timesAdd, timesAddFront, timesAddBack;
    int timesRemove, timesRemoveFront, timesRemoveBack;
    Elem name;

    cout << "Please input timesAdd: ";
    cin >> timesAdd;
    cout << "Please input names:\n";
    while (timesAdd--) {
        cin >> name;
        dLinkedList->add(dLinkedList->trailer, name);
    }

    cout << "Please input timesAddFront: ";
    cin >> timesAddFront;
    if (timesAddFront) cout << "Please input namesAddFront:\n";
    while (timesAddFront--) {
        cin >> name;
        dLinkedList->addFront(name);
    }

    cout << "Please input timesAddBack: ";
    cin >> timesAddBack;
    if (timesAddBack) cout << "Please input namesAddBack:\n";
    while (timesAddBack--) {
        cin >> name;
        dLinkedList->addBack(name);
    }

    cout << "Please input timesRemove: ";
    cin >> timesRemove;
    if (timesRemove) cout << "Please input namesRemove:\n";
    while (timesRemove--) {
        cin >> name;
        dLinkedList->remove(dLinkedList->getNode(name));
    }

    cout << "Please input timesRemoveFront: ";
    cin >> timesRemoveFront;
    while (timesRemoveFront--) dLinkedList->removeFront();

    cout << "Please input timesRemoveBack: ";
    cin >> timesRemoveBack;
    while (timesRemoveBack--) dLinkedList->removeBack();

    dLinkedList->printList();

    return 0;
}