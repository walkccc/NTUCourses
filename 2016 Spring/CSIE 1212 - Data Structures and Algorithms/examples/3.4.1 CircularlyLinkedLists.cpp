#include <iostream>
using namespace std;

typedef string Elem;
class CNode {
private:
    Elem elem;
    CNode* next;
    friend class CircleList;
};

class CircleList {
public:
    CircleList();
    ~CircleList();
    bool empty() const;
    const Elem& getFront() const;
    const Elem& getBack() const;
    void advance();
    void add(const Elem& e);
    void remove(const Elem& e);
    void printList();

private:
    CNode* cursor;
};

CircleList::CircleList() : cursor(NULL) {}
CircleList::~CircleList() {
    while (!empty()) remove();
}

bool CircleList::empty() const { return cursor == NULL; }
const Elem& CircleList::getBack() const { return cursor->elem; }
const Elem& CircleList::getFront() const { return cursor->next->elem; }
void CircleList::advance() { cursor = cursor->next; }

void CircleList::add(const Elem& e) {
    CNode* v = new CNode;
    v->elem = e;
    if (cursor == NULL) {
        v->next = v;
        cursor = v;
    } else {
        v->next = cursor->next;
        cursor->next = v;
    }
}

void CircleList::remove() {
    CNode* old = cursor->next;
    if (old == cursor)
        cursor = NULL;
    else
        cursor->next = old->next;
    delete old;
}

void CircleList::printList() {
    for (CNode* i = cursor; i->next->elem != cursor->elem; i = i->next)
        cout << i->elem << " ";
}
/*
int main() {
        CircleList playList;
        playList.add("Stayin Alive");
        playList.printList();
        playList.add("Le Freak");
        playList.printList();
        playList.add("Jive Talkin");
        playList.printList();

        playList.advance();
        playList.printList();
        playList.advance();
        playList.printList();
        playList.remove();
        playList.printList();
        playList.add("Disco Inferno");
        playList.printList();
        return EXIT_SUCCEED;

}*/