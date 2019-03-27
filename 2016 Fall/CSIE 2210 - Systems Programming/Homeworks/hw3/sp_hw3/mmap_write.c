/* mmap_write.c */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

typedef struct {
    char c_time_string[100];
} TimeInfo;

int main(int argc, char** argv) {
    int fd, i;
    time_t current_time;
    char c_time_string[100];
    TimeInfo* p_map;
    const char* file = "time_test.txt";

    fd = open(file, O_RDWR | O_TRUNC | O_CREAT, 0777);
    if (fd < 0) {
        perror("open");
        exit(-1);
    }
    lseek(fd, sizeof(TimeInfo), SEEK_SET);
    write(fd, "", 1);

    p_map = (TimeInfo*)mmap(0, sizeof(TimeInfo), PROT_READ | PROT_WRITE,
                            MAP_SHARED, fd, 0);
    printf("mmap address:%#x\n", (unsigned int)&p_map);  // 0x00000
    close(fd);

    current_time = time(NULL);
    strcpy(c_time_string, ctime(&current_time));

    memcpy(p_map->c_time_string, &c_time_string, sizeof(c_time_string));

    printf("initialize over\n ");

    munmap(p_map, sizeof(TimeInfo));
    printf("umap ok \n");

    fd = open(file, O_RDWR);
    p_map = (TimeInfo*)mmap(0, sizeof(TimeInfo), PROT_READ, MAP_SHARED, fd, 0);
    printf("%s\n", p_map->c_time_string);

    return 0;
}