#define _GNU_SOURCE
#define NUM_THREADS 2

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <linux/sched.h>

cpu_set_t mask;
void *thread_func(void *param);
static double clk();

int main(int argc, char **argv) {
	/* Run the program by real-time scheduling policy (FIFO) */
	if (argc == 2 && strcmp(argv[1], "SCHED_FIFO") == 0) {
		CPU_ZERO(&mask);
		CPU_SET(0, &mask);
		sched_setaffinity(0, sizeof(mask), &mask);
		struct sched_param param; 
		param.sched_priority = sched_get_priority_max(SCHED_FIFO);
		sched_setscheduler(0, SCHED_FIFO, &param);
	}
	
	pthread_t tid[NUM_THREADS];
	pthread_attr_t attr;
	pthread_attr_init(&attr);

	/* create the threads */
	for (int i = 0; i < NUM_THREADS; i++) {
		int *ptr = (int *)malloc(sizeof(int));
		*ptr = i;
		pthread_create(&tid[i], &attr, thread_func, (void *)ptr);
		printf("Thread %d was created\n", i + 1);	
	}

	for (int i = 0; i < NUM_THREADS; i++)
		pthread_join(tid[i], NULL);

	return 0;
}

void *thread_func(void *param) {
	for (int i = 0; i < 3; i++) {
		printf("Thread %d is running\n", *((int *) param) + 1);
		double curr_time = clk();
		while (clk() - curr_time <= 0.5) ;
	}
}

static double clk() {
	struct timespec t;
	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &t);
	return 1e-9 * t.tv_nsec + t.tv_sec;
}

