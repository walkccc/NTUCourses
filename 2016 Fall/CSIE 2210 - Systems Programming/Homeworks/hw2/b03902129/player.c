/* b03902129 陳鵬宇 */
#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {
    FILE* fp[2];
    char fifo[2][20] = {"judge", "judge"};

    strcat(fifo[0], argv[1]);
    if (strcmp("A", argv[2]) == 0) strcat(fifo[0], "_A.FIFO");
    if (strcmp("B", argv[2]) == 0) strcat(fifo[0], "_B.FIFO");
    if (strcmp("C", argv[2]) == 0) strcat(fifo[0], "_C.FIFO");
    if (strcmp("D", argv[2]) == 0) strcat(fifo[0], "_D.FIFO");
    fp[0] = fopen(fifo[0], "r+");

    strcat(fifo[1], argv[1]);
    strcat(fifo[1], ".FIFO");
    fp[1] = fopen(fifo[1], "w+");

    int a = 1, b = 3, c = 3, d = 5;
    for (int i = 0; i < 20; i++) {
        if (i == 0) { /* first send */
            if (strcmp("A", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "A", argv[3], a);
            else if (strcmp("B", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "B", argv[3], b);
            else if (strcmp("C", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "C", argv[3], c);
            else if (strcmp("D", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "D", argv[3], d);
            fflush(fp[1]);
        } else {
            fscanf(fp[0], "%d %d %d %d", &a, &b, &c, &d);
            fflush(fp[0]);
            if (strcmp("A", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "A", argv[3], a);
            else if (strcmp("B", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "B", argv[3], b);
            else if (strcmp("C", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "C", argv[3], c);
            else if (strcmp("D", argv[2]) == 0)
                fprintf(fp[1], "%s %s %d\n", "D", argv[3], d);
            fflush(fp[1]);
        }
    }
    fclose(fp[0]);
    fclose(fp[1]);

    return 0;
}
