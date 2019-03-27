#include <iostream>
using namespace std;

void insertionSort(char* A, int n) {
    for (int i = 1; i < n; i++) {
        char cur = A[i];
        int j = i - 1;
        while (j >= 0 && A[j] > cur) {
            A[j + 1] = A[j];
            j--;
        }
        A[j + 1] = cur;
    }
}

void printArray(char* A, int n) {
    for (int i = 0; i < n; i++) cout << A[i];
}

int main() {
    int n;
    cin >> n;
    char* array = new char[n];
    for (int i = 0; i < n; i++) cin >> array[i];
    insertionSort(array, n);
    printArray(array, n);
    return 0;
}