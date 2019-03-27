typedef string Elem;
class LinkdeQuene {
public:
    LinkdeQuene();
    int size() const;
    bool empty() const;
    const Elem& getFront();
    void enquene(const Elem& e);
    void dequene();

private:
    CircleList C;
    int n;
};

LinkdeQuene::LinkdeQuene() : C(), n(0) {}
int LinkdeQuene::size() const { return n; }
bool LinkdeQuene::empty() const { return n == 0; }

const Elem& LinkdeQuene::getFront() {
    if (empty()) return "ERROR";
    return C.front();
}

void LinkdeQuene::enquene(const Elem& e) {
    C.add(e);
    C.advance();
    n++;
}

void LinkdeQuene::dequene() {
    if (empty()) return;
    C.remove();
    n--;
}