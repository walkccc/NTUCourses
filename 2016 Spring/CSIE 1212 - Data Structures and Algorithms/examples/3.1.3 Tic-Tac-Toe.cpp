#include <cstdlib>
#include <iostream>
using namespace std;

const int X = 1, O = -1, EMPTY = 0;
int board[3][3];
int curPlayer;

void clearBoard() {
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			board[i][j] = EMPTY;
	curPlayer = X;
}

void putMark(int i, int j) {
	board[i][j] = curPlayer;
	curPlayer *= -1;
}

bool isWin(int mark) {
	int win = 3 * mark;
	int sumByRow = 0, sumByCol = 0;
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			sumByRow += board[i][j];
			sumByCol += board[j][i];
		}
		if (sumByRow == win || sumByCol == win)
			return true;
		else
			sumByRow = 0, sumByCol = 0;
	}

	return ((board[0][0] + board[1][1] + board[2][2] == win) 
		|| 	(board[2][0] + board[1][1] + board[0][2] == win));
}

int getWinner() {
	if (isWin(X)) return X;
	else if (isWin(O)) return O;
	else return EMPTY;
}

void printBoard() {
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			switch (board[i][j]) {
				case X:		cout << "X"; break;
				case O:		cout << "O"; break;
				case EMPTY: cout << " "; break;
			}
			if (j < 2) cout << "|";
		}
		if (i < 2) cout << "\n-+-+-\n";
	}
}

int main() {
	clearBoard();
	int x, y;
	int T = 9;
	cout << "Please input (x, y):";
	while (T--) {
		cin >> x >> y;
		putMark(x, y);
		if (getWinner() == X || getWinner() == O)
			break;
	}

	printBoard();
	if (getWinner() == X)
		cout << "  X wins\n";
	else if (getWinner() == O)
		cout << "  O wins\n";
	else
		cout << "  Tie\n";

	return EXIT_SUCCESS;
}









