/* b03902129 陳鵬宇 */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h> /* wait() */
#include <time.h>
#include <unistd.h>

void error(const char* msg) {
    perror(msg);
    exit(0);
}

int main(int argc, char* argv[]) {
    int status;
    char buf[256];
    FILE* fp[5];
    int fd[5];
    int pid[4];
    char random_key[4][20];
    int player[4];

    srand(time(NULL));
    while (1) {
        scanf("%d%d%d%d", &player[0], &player[1], &player[2], &player[3]);
        fflush(stdin);
        if (player[0] == -1) {
            for (int i = 0; i < 4; i++) wait(&status);
            break;
        } else {
            for (int i = 0; i < 4; i++)
                sprintf(random_key[i], "%d", rand() % 65535);

            char fifo[5][20] = {"judge", "judge", "judge", "judge", "judge"};
            for (int i = 0; i < 5; i++) {
                strcat(fifo[i], argv[1]);
                if (i == 0) strcat(fifo[0], "_A.FIFO");
                if (i == 1) strcat(fifo[1], "_B.FIFO");
                if (i == 2) strcat(fifo[2], "_C.FIFO");
                if (i == 3) strcat(fifo[3], "_D.FIFO");
                if (i == 4) strcat(fifo[4], ".FIFO");
                mkfifo(fifo[i], 0777);
            }

            for (int i = 0; i < 4; i++) {
                if ((pid[i] = fork()) < 0) error("ERROR fork()\n");
                if (pid[i] == 0 && i == 0)
                    execl("./player", "./player", argv[1], "A", random_key[0],
                          (char*)0);
                if (pid[i] == 0 && i == 1)
                    execl("./player", "./player", argv[1], "B", random_key[1],
                          (char*)0);
                if (pid[i] == 0 && i == 2)
                    execl("./player", "./player", argv[1], "C", random_key[2],
                          (char*)0);
                if (pid[i] == 0 && i == 3)
                    execl("./player", "./player", argv[1], "D", random_key[3],
                          (char*)0);
            }

            for (int i = 0; i < 4; i++) {
                fp[i] = fopen(fifo[i], "w+");
                fd[i] = fileno(fp[i]);
                int flags = fcntl(fd[i], F_GETFL, 0);
                fcntl(fd[i], F_SETFL, flags | O_NONBLOCK);
            }
            fp[4] = fopen(fifo[4], "r+");
            fd[4] = fileno(fp[4]);

            int A = 0, B = 0, C = 0, D = 0;
            char player_id[20];
            int number_choose = 0, key;
            int rank[4] = {0};
            int score[4] = {0};
            for (int i = 0; i < 20; i++) {
                for (int j = 0; j < 4; j++) {
                    fscanf(fp[4], "%s%d%d", player_id, &key,
                           &number_choose); /* judge read from 4 players via
                                               judge[num].FIFO*/
                    fflush(fp[4]);
                    if (number_choose != 0) {
                        if (strcmp("A", player_id) == 0) A = number_choose;
                        if (strcmp("B", player_id) == 0) B = number_choose;
                        if (strcmp("C", player_id) == 0) C = number_choose;
                        if (strcmp("D", player_id) == 0) D = number_choose;
                    }
                }
                if (A != B && A != C && A != D) score[0] += A;
                if (B != A && B != C && B != D) score[1] += B;
                if (C != A && C != B && C != D) score[2] += C;
                if (D != A && D != B && D != C) score[3] += D;

                /* judge write result to 4 players via FIFO */
                for (int i = 0; i < 4; i++) {
                    fprintf(fp[i], "%d %d %d %d\n", A, B, C, D);
                    fflush(fp[i]);
                }
            } /* end of forloop */

            sprintf(buf, "%d %d\n%d %d\n%d %d\n%d %d\n", player[0], score[0],
                    player[1], score[1], player[2], score[2], player[3],
                    score[3]);
            printf("%s", buf);
            fflush(stdout);

            for (int i = 0; i < 4; i++) wait(&status);
            for (int i = 0; i < 5; i++) fclose(fp[i]);
            for (int i = 0; i < 5; i++) unlink(fifo[i]);
        }
    }
    return 0;
}
