#include <iostream>
#include <algorithm>
#include <cctype>
#include <cmath>
#include <fstream>
#include <list>
#include <queue>
#include <set>
#include <string>
#include <utility>
#include <vector>

using namespace std;
#define PRIME 41929379
// #define PRIME 8627147
#define z 33
#define NUM 20

string prep[NUM] = {"of", "to", "in", "for", "with",
    "on", "at", "by", "from", "up",
    "about", "than", "after", "before", "down",
    "between", "under", "since", "without", "near"};

struct P {
    string sentence;
    int freq;
};
typedef list<P> L;
typedef vector<L> V;
V dict;

bool cmpString(string& a, string &b) { return a < b; }
bool cmp(P a, P b) { return a.freq > b.freq; }

int keyCalculator(string str) {
    int key = 0;
    for (long int i = str.size() - 1; i >= 0; i--) {
        key += str[i];
        if (i) key *= z;
    }
    return key;
}

void readfile(int file) {
    ifstream fin; 
    if (file == 2) fin.open("/tmp2/dsa2016_project/2gm.small.txt");
    else if (file == 3) fin.open("/tmp2/dsa2016_project/3gm.small.txt");
    else if (file == 4) fin.open("/tmp2/dsa2016_project/4gm.small.txt");
    else if (file == 5) fin.open("/tmp2/dsa2016_project/5gm.small.txt");

    string buf;
    while (getline(fin, buf)) {
        int i = 0;
        while (!isdigit(buf[i])) i++;
        string sentence;
        sentence.assign(buf, 0, i - 1);
        
        int freq = 0;
        for (long int j = buf.size() - 1, x = 1; buf[j] != ' ' && buf[j] != '\t'; j--, x *= 10)
            freq += (buf[j] - '0') * x;
        int key = keyCalculator(sentence);       /* hash code */
        int idx = abs(key % PRIME);              /* compression function */
        
        P p;
        p.sentence = sentence;
        p.freq = freq;
        dict[idx].push_back(p);
    }
}
void initTable() {
    dict.resize(PRIME);
    for (int i = 2; i <= 5; i++)
        readfile(i);
}

int parts(string str) {
    int cnt = 1;
    for (int i = 0; i < str.size(); i++)
        if (str[i] == ' ' || str[i] == '\0')
            cnt++;
    return cnt;
}

bool hasPrep(string str) {
    int pos = 0;
    bool hasPrep = false;
    for (int i = 0; i < str.size(); i++)
        if (str[i] == ' ' || str[i] == '\n' || str[i] == '\0') {
            string strWords;
            strWords.assign(str, pos, i - pos);
            pos = i + 1;
            for (int i = 0; i < NUM; i++) {
                if (strWords.compare(prep[i]) == 0) {
                    hasPrep = true;
                    return hasPrep;
                }
            }
        }
    
    string strWords;
    strWords.assign(str, pos, str.size() - pos);
    for (int i = 0; i < NUM; i++)
        if (strWords.compare(prep[i]) == 0) {
            hasPrep = true;
            return hasPrep;
        }
    
    return hasPrep;
}

vector<string> sets;
void insertPrep(string str) {
    for (int i = 0; i < NUM; i++) {
        string tmp = str;
        sets.push_back(tmp.insert(0, prep[i] + " "));
    }
    for (int i = 0; i < str.size(); i++)
        if (str[i] == ' ' || str[i] == '\0')
            for (int j = 0; j < NUM; j++) {
                string tmp = str;
                sets.push_back(tmp.insert(i, " " + prep[j]));
            }
    
    for (int i = 0; i < NUM; i++) {
        string tmp = str;
        sets.push_back(tmp.insert(str.size(), " " + prep[i]));
    }
}

void generateSets(string str) {
    if (parts(str) <= 4)
        insertPrep(str);
    if (parts(str) <= 3) {
        long int capa = sets.size();
        for (int i = 0; i < capa; i++)
            insertPrep(sets[i]);
    }
}

bool isPrep(string str) {
    for (int i = 0; i < NUM; i++)
        if (str.compare(prep[i]) == 0)
            return true;
    return false;
}

struct W {
    string word;
    bool isPrep;
};
typedef list<W> SL;
typedef vector<SL> SV;

list<string> vida;

void edit(string str, SL::iterator begin, SL::iterator end) {
    //insert
    string combine;
    int cnt = 0;
    for (SL::iterator it = begin; it != end; it++) {
        if (str.compare("") == 0 && it == begin)
            combine += it->word;
        else
            combine += (" " + it->word);
        cnt ++;
    }
    
    if (str.compare("") == 0)
        for (int j = 0; j < NUM; j++) {
            string tmp = combine;
            vida.push_back(str + tmp.insert(0, prep[j] + " "));
        }
    
    for (int i = 0; i < combine.size(); i++)
        if (combine[i] == ' ' || combine[i] == '\0')
            for (int j = 0; j < NUM; j++) {
                string tmp = combine;
                vida.push_back(str + tmp.insert(i, " " + prep[j]));
            }
    
    for (int i = 0; i < NUM; i++) {
        string tmp = combine;
        vida.push_back(str + tmp.insert(tmp.size(), " " + prep[i]));
    }
    
    //sub
    for (int pos = 0; pos < cnt; pos++) {
        for (int i = 0; i < NUM; i++) {
            string tmp;
            int j = 0;
            for (SL::iterator it = begin; it != end; it++, j++) {
                if (j == pos) {
                    if (str.compare("") == 0 && it == begin)
                        tmp += prep[i];
                    else tmp += (" " + prep[i]);
                }
                else {
                    if (str.compare("") == 0 && it == begin)
                        tmp += it->word;
                    else tmp += (" " + it->word);
                }
            }
            vida.push_back(str + tmp);
        }
    }
    
    //delete
    for (int pos = 0; pos < cnt; pos++) {
        string tmp;
        int j = 0;
        for (SL::iterator it = begin; it != end; it++, j++) {
            if (j == pos)
                continue;
            else {
                if (str.compare("") == 0 && (it == begin || pos == 0))
                    tmp += it->word;
                else tmp += (" " + it->word);
            }
        }
        vida.push_back(str + tmp);
    }
}

void readInput() {
    string buffer;
    while (getline(cin, buffer)) {
        vector<P> correct;
        sets.push_back(buffer);
        
        /* !hasPrep */
        if (!hasPrep(buffer)) {
            generateSets(buffer);
            sort(sets.begin(), sets.end(), cmpString);
            vector<string>::iterator it;
            it = unique(sets.begin(), sets.end());
            sets.resize(distance(sets.begin(), it));
            
            for (int i = 0; i < sets.size(); i++) {
                int key = keyCalculator(sets[i]);
                int idx = abs(key % PRIME);
                for (L::iterator it = dict[idx].begin(); it != dict[idx].end(); it++)
                    if (sets[i].compare(it->sentence) == 0) {
                        P o;
                        o.sentence = it->sentence;
                        o.freq = it->freq;
                        correct.push_back(o);
                    }
            }
        }
        
        /* hasPrep */
        else {
            SV seq;
            vector<string> unit;
            int pos = 0;
            for (int i = 0; i < buffer.size(); i++) {
                if (buffer[i] == ' ' || buffer[i] == '\n' || buffer[i] == '\0') {
                    string strWords;
                    strWords.assign(buffer, pos, i - pos);
                    unit.push_back(strWords);
                    pos = i + 1;
                }
            }
            string strWords;
            strWords.assign(buffer, pos, buffer.size() - pos);
            unit.push_back(strWords);
            seq.resize(100);
            
            int index = 0;
            for (int i = 0; i < unit.size(); i++) {
                if (isPrep(unit[i])) {
                    if (i && !isPrep(unit[i - 1]))
                        index++;
                    W w;
                    w.word = unit[i];
                    w.isPrep = true;
                    seq[index].push_back(w);
                }
                if (!isPrep(unit[i])) {
                    if (i && isPrep(unit[i - 1]))
                        index++;
                    W w;
                    w.word = unit[i];
                    w.isPrep = false;
                    seq[index].push_back(w);
                }
            }
            index++;
            
            for (int i = 0; i < index; i++) {
                SL::iterator it = seq[i].begin();
                if (!isPrep(it->word)) {
                    if (vida.size()) {
                        long int capa = vida.size();
                        for (int j = 0; j < capa; j++) {
                            string comb;
                            for (SL::iterator it = seq[i].begin(); it != seq[i].end(); it++) {
                                if (vida.front().compare("") == 0 && it == seq[i].begin())
                                    comb += it->word;
                                else comb += (" " + it->word);
                            }
                            vida.push_back(vida.front() + comb);
                            vida.pop_front();
                        }
                    }
                    else {
                        string comb;
                        for (SL::iterator it = seq[i].begin(); it != seq[i].end(); it++) {
                            if (it == seq[i].begin())
                                comb += it->word;
                            else comb += (" " + it->word);
                        }
                        vida.push_back(comb);
                    }
                }
                else if (isPrep(it->word)) {
                    if (vida.size()) {
                        long int capa = vida.size();
                        for (int j = 0; j < capa; j++) {
                            edit(vida.front(), seq[i].begin(), seq[i].end());
                            vida.pop_front();
                        }
                    }
                    else edit("", seq[i].begin(), seq[i].end());
                }
            }
            vida.push_back(buffer);
            vida.sort();
            vida.unique();
            
            while (!vida.empty()) {
                int key = keyCalculator(vida.front());
                int idx = abs(key % PRIME);
                for (L::iterator it = dict[idx].begin(); it != dict[idx].end(); it++) {
                    if (vida.front().compare(it->sentence) == 0) {
                        P o;
                        o.sentence = it->sentence;
                        o.freq = it->freq;
                        correct.push_back(o);
                    }
                }
                vida.pop_front();
            }
        }
        cout << "query: " << buffer << endl;
        if (correct.size() >= 10) cout << "output: 10" << endl;
        else cout << "output: " << correct.size() << endl;
        
        sort(correct.begin(), correct.end(), cmp);
        for (int i = 0; i < correct.size(); i++) {
            if (i >= 10) break;
            cout << correct[i].sentence << "\t" << correct[i].freq << endl;
        }
        sets.clear();
    }
}

void printTable() {
    int i = 0;
    int tmp = 0;
    for (V::iterator iter = dict.begin(); iter < dict.begin() + PRIME; iter++, i++) {
        cout << "No." << i << " ";
        int cnt = 0;
        for (L::iterator it = iter->begin(); it != iter->end(); it++) {
            cout << it->sentence << " " << it->freq << "\t";
            cnt++;
        }
        if (cnt > tmp) tmp = cnt;
        cout << endl;
    }
    cout << "The longest list is " << tmp << endl;
}
int main() {
    initTable();
    // printTable();
    readInput();
    
    return 0;
}