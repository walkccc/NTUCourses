#include <linux/kernel.h>
#include <linux/linkage.h>

asmlinkage int sys_hello(void) {
	printk("HELLO SYSTEM CALL B03902129 B03505053");
	return 0;
}
