#include <linux/kernel.h>
#include <linux/linkage.h>

asmlinkage int sys_multiply(long a, long b) {
	return a * b;
}	
