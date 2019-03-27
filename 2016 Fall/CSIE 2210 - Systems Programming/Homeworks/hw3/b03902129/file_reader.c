/* b03902129 陳鵬宇 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define ERR_EXIT(a) \
    {               \
        perror(a);  \
        exit(1);    \
    }

int main() {
    char c;
    char send[1024];
    char recv[1024];
    int i = 0;

    read(STDIN_FILENO, recv, sizeof(recv));

    int mapfd = open("info.txt", O_RDWR, 0777);

    /* Map the time */
    time_t now = time(NULL);
    char ctime_string[128];
    strcpy(ctime_string, ctime(&now));
    write(mapfd, ctime_string, 128);

    /* Map the file */
    write(mapfd, recv, 128);

    FILE* fp = fopen(recv, "r");
    if (fp == NULL) ERR_EXIT("ERROR open!\n")
    while ((c = fgetc(fp)) != EOF) {
        send[i] = c;
        i++;
    }
    send[i] = '\0';
    write(STDOUT_FILENO, send, strlen(send));
    fclose(fp);
    sleep(2);
    return 0;
}
