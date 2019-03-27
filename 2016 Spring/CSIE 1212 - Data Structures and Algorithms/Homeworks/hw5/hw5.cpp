#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <list>
#include <cctype>
#include <utility>
#include <cmath>
#include <set>
#include <algorithm>
#define PRIME 350377
#define NUM 133852
#define z 33

using namespace std;
typedef pair<int, string> P;
typedef list<P> L;
typedef vector<L> V;
typedef vector<string> S;
V dict;

int keyCalculator(string str) {
    int key = 0;
    for (int i = str.size() - 1; i >= 0; i--) {
        key += str[i];
        if (i) key *= z;
    }
    return key;
}

void initTable() {
    dict.resize(PRIME);
    string buf;
    //ifstream fp("/tmp2/dsa2016_hw5/cmudict-0.7b");
    ifstream fp("cmudict-0.7b.txt");
    int cnt = 0;
    while (getline(fp, buf)) {
        cnt++;
        if (cnt >= 56) {
            char charWord[100];
            int i;
            for (i = 0; buf[i] != ' '; i++)
                charWord[i] = tolower(buf[i]);
            charWord[i] = '\0';
            string strWord;
            strWord.assign(charWord);
            int key = keyCalculator(strWord);       /* hash code */
            int idx = abs(key % PRIME);             /* compression function */
            dict[idx].push_back(P(key, strWord));
        }
    }
}

vector<string> correctWord;
set<string> printed;
bool isPrinted;
void printWord(string str) {
    int key = keyCalculator(str);
    int idx = abs(key % PRIME);
    for (L::iterator it = dict[idx].begin(); it != dict[idx].end(); it++) {
        if (str == it->second){
            if (printed.find(str) != printed.end())
                break;
            else {
                correctWord.push_back(str);
                printed.insert(str);
            }
        }
    }
}

typedef string::iterator strit;
void edit(string &s, vector<string> &vs) {
    for (int j = 0; j <= s.size(); j++) {       /* insert */
        for (char k = 'a'; k <= 'z'; k++) {
            if (s[j - 1] != k) {
                string tmp = s;
                tmp.insert(j, 1, k);                    
                vs.push_back(tmp);
            }
        }
    }
    for (int j = 0; j < s.size(); j++) {        /* delete */
        string tmp = s;
        tmp.erase(j, 1);
        vs.push_back(tmp);
    }
    for (int j = 0; j < s.size(); j++) {        /* substitue */
        for (char k = 'a'; k <= 'z'; k++) {
            if (s[j] != k) {
                string tmp = s;
                tmp[j] = k;
                vs.push_back(tmp);
            }
        }
    }
    for (int j = 0; j < s.size() - 1; j++) {   /* transpose */
        if (s[j] != s[j + 1]) {
            string tmp = s;
            char c = tmp[j];
            tmp[j] = tmp[j + 1];
            tmp[j + 1] = c;
            vs.push_back(tmp);
        }
    }
}

void edit2(vector<string> &vs) {
    for (int i = 0; i < vs.size(); i++) {
        string st = vs[i];
        for (int j = 0; j <= st.size(); j++) {      /* insert */
            for (char k = 'a'; k <= 'z'; k++) {
                if (st[j - 1] != k) {
                    string tmp = st;
                    tmp.insert(j, 1, k);
                    printWord(tmp);
                }
            }
        }
        for (int j = 0; j < st.size(); j++) {       /* delete */
            string tmp = st;
            tmp.erase(j, 1);
            printWord(tmp);
        }
        for (int j = 0; j < st.size(); j++) {       /* substitute */
            for (char k = 'a'; k <= 'z'; k++) {
                if (st[j] != k) {
                    string tmp = st;
                    tmp[j] = k;
                    printWord(tmp);
                }
            }
        }
        for (int j = 0; j < st.size() - 1; j++) {   /* transpose */
            if (st[j] != st[j + 1]) {
                string tmp = st;
                char c = tmp[j];
                tmp[j] = tmp[j + 1];
                tmp[j + 1] = c;
                printWord(tmp);
            }
        }
    }
}

void readInput() {
    string buffer;
    while (getline(cin, buffer)) {
        char charWords[100];
        int i;
        for (i = 0; buffer[i] != ' ' && buffer[i] != '\t' && buffer[i] != '\n' && buffer[i] != '\0'; i++)
            charWords[i] = buffer[i];
        charWords[i] = '\0';
        string strWords;
        strWords.assign(charWords);
        isPrinted = false;
        cout << strWords << " ==>";
        bool OK = false;
        int key = keyCalculator(strWords);
        int idx = abs(key % PRIME);
        for (L::iterator it = dict[idx].begin(); it != dict[idx].end(); it++) {
            if (strWords == it->second){
                cout << " OK";
                OK = true;
            }
        }
    
        if (!OK) {
            S vs;
            edit(strWords, vs);
            edit2(vs);
            sort(correctWord.begin(), correctWord.end());
            bool first = true;
            for (int i = 0; i < correctWord.size(); i++) 
                cout << " " << correctWord[i];
            correctWord.clear();
            if (!printed.size()) 
                cout << " NONE";
            printed.clear();
        }   
        cout << endl;
    }
}

void printTable() {
    int i = 0;
    for (V::iterator iter = dict.begin(); iter < dict.begin() + PRIME; iter++, i++) {
        cout << "No." << i << " ";
        for (L::iterator it =  iter->begin(); it != iter->end(); it++)
             cout << it->first << " " << it->second << "\t";
        cout << endl;
    }
}

int main() {
    initTable();
    readInput();
    printTable();

    return 0;
}
