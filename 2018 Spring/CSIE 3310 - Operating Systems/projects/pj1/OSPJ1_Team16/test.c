#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>

int main() {
	syscall(337);
	printf("multiply = %ld\n", syscall(338, 8, 7));
	printf("min = %ld\n", syscall(339, 8, 7));
	return 0;
}
