/* b03902129 陳鵬宇 */
#include <fcntl.h>    /* read(), write() */
#include <stdio.h>    /* sprintf() */
#include <stdlib.h>   /* atoi() */
#include <string.h>   /* strlen() */
#include <sys/wait.h> /* wait() */
#include <unistd.h>   /* pipe(), FIFO() */

void error(const char* msg) {
    perror(msg);
    exit(0);
}

typedef struct {
    int index;
    int score;
} Rank;

int cmp(const void* a, const void* b) {
    Rank* x = (Rank*)a;
    Rank* y = (Rank*)b;
    if (x->score >= y->score)
        return -1;
    else if (x->score <= y->score)
        return 1;
    else if (x->index >= y->score)
        return -1;
    else if (x->index <= y->score)
        return 1;
    else
        return 0;
}

int main(int argc, char* argv[]) {
    int judge_num = atoi(argv[1]);  /* 1 <= judge_num <= 12 */
    int player_num = atoi(argv[2]); /* 4 <= player_num <= 20 */
    int judge[judge_num + 1][2];    /* pipe (big_judge to judge) */
    int big[judge_num + 1][2];      /* pipe (judge to big_judge) */
    pid_t pid[judge_num + 1];       /* processID of each judges */
    char judge_id[3];               /* To store judge_id in char */
    char list[5000][200], buf[200]; /* To store the competitions combinations */
    fd_set set, tset;
    FD_ZERO(&set);
    FD_ZERO(&tset);

    Rank rank[player_num];
    for (int i = 0; i < player_num; i++) { /* Initialize the rank */
        rank[i].index = i;
        rank[i].score = 0;
    }

    for (int i = 0; i < judge_num; i++) {
        pipe(judge[i]);
        pipe(big[i]);
        FD_SET(big[i][0], &set);   /* FD_SET the input */
        if ((pid[i] = fork()) < 0) /* fork() */
            error("ERROR fork()\n");
        else if (pid[i] == 0) {             /* Child process */
            sprintf(judge_id, "%d", i + 1); /* Convert int to char */
            fflush(NULL);
            dup2(judge[i][0], STDIN_FILENO); /* Judge read from stdin */
            dup2(big[i][1], STDOUT_FILENO);  /* Judge write to stdout */
            execl("./judge", "./judge", judge_id, (char*)0);
        } else { /* Parent process */
            close(judge[i][0]);
            close(big[i][1]);
        }
    }

    /* Assign C(player_num, 4) competitions */
    int cnt = 0;
    for (int a = 1; a <= player_num; a++)
        for (int b = a + 1; b <= player_num; b++)
            for (int c = b + 1; c <= player_num; c++)
                for (int d = c + 1; d <= player_num; d++) {
                    sprintf(list[cnt], "%d %d %d %d\n", a, b, c, d);
                    fflush(NULL);
                    cnt++;
                }

    /* First assign */
    int curr = 0;
    for (int i = 0; i < judge_num; i++)
        if (curr < cnt) {
            write(judge[i][1], list[curr], strlen(list[curr]));
            curr++;
        }

    int turn = 0;
    int jid;
    while (turn < cnt) {
        // fprintf(stderr, "----------\nturn = %d\n----------\n", turn);
        tset = set;
        select(256, &tset, NULL, NULL, NULL);
        for (int i = 0; i < judge_num; i++) /* Determine which judge is ready */
            if (FD_ISSET(big[i][0], &tset)) {
                jid = i;
                break;
            }

        if (curr < cnt) {
            write(judge[jid][1], list[curr], strlen(list[curr]));
            curr++;
        }

        char result[50];
        read(big[jid][0], result, sizeof(result));
        int idx[4], pts[4];
        sscanf(result, "%d%d%d%d%d%d%d%d", &idx[0], &pts[0], &idx[1], &pts[1],
               &idx[2], &pts[2], &idx[3], &pts[3]);
        fflush(NULL);
        for (int i = 0; i < 4; i++) rank[idx[i] - 1].score += pts[i];
        turn++;
        // for (int i = 0; i < player_num; i++) {
        //     fprintf(stderr, "score[%d] = %d\n", i, rank[i].score);
        // }
    }

    qsort((void*)rank, player_num, sizeof(Rank), cmp);
    for (int i = 0; i < player_num; i++) {
        fprintf(stderr, "%d %d\n", rank[i].index + 1, rank[i].score);
        fflush(NULL);
    }
    sprintf(buf, "-1 -1 -1 -1\n");

    /*  int tot = 0;
    for (int i = 0; i < player_num; i++)
        tot += rank[i].score;
    fprintf(stderr, "tot = %d\n", tot); */

    int status;
    for (int i = 0; i < judge_num; i++) { /* Wait for zombies */
        write(judge[i][1], buf, strlen(buf));
        wait(&status);
    }
    return 0;
}
