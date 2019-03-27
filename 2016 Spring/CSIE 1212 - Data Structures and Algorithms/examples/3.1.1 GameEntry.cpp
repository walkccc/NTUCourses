#include <iomanip>
#include <iostream>
using namespace std;

class GameEntry {
public:
    GameEntry(const string& n = "", int s = 0);
    string getName() const;
    int getScore() const;

private:
    string name;
    int score;
};

GameEntry::GameEntry(const string& n, int s) : name(n), score(s) {}
string GameEntry::getName() const { return name; }
int GameEntry::getScore() const { return score; }

class Scores {
public:
    Scores(int maxEnt = 10);
    ~Scores();
    void add(const GameEntry& e);
    void printScores();

private:
    int maxEntries;
    int numEntries;
    GameEntry* entries;
};

Scores::Scores(int maxEnt) {
    maxEntries = maxEnt;
    entries = new GameEntry[maxEntries];
    numEntries = 0;
}

Scores::~Scores() { delete[] entries; }

void Scores::add(const GameEntry& e) {
    int newScore = e.getScore();
    if (numEntries == maxEntries) {
        if (newScore < entries[maxEntries - 1].getScore()) return;
    } else
        numEntries++;

    int i = numEntries - 2;
    while (i >= 0 && newScore > entries[i].getScore()) {
        entries[i + 1] = entries[i];
        i--;
    }
    entries[i + 1] = e;
}

void Scores::printScores() {
    cout << setw(3) << "No" << setw(10) << "Name" << setw(10) << "Score"
         << endl;
    for (int i = 0; i < numEntries; i++)
        cout << setw(3) << i + 1 << setw(10) << entries[i].getName() << setw(10)
             << entries[i].getScore() << endl;
}

int main() {
    Scores* scores = new Scores();

    int n;
    cout << "Please input the number of entries: ";
    cin >> n;

    string name;
    int score;
    cout << "Please input the names and scores: \n";
    for (int i = 0; i < n; i++) {
        cin >> name;
        cin >> score;
        GameEntry* game = new GameEntry(name, score);
        scores->add(*game);
    }
    scores->printScores();

    return 0;
}