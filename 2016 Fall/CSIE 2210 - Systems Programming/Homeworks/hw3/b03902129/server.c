/* b03902129 陳鵬宇 */
#include <arpa/inet.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define MAXBUFSIZE 1024  // timeout in seconds for wait for a connection
#define NO_USE 0         // status of a http request
#define ERROR -1
#define READING 1
#define ERR_EXIT(a) \
    {               \
        perror(a);  \
        exit(1);    \
    }

#define ALIVE 1
#define DIED 0

typedef struct {
    char hostname[512];   // hostname
    unsigned short port;  // port to listen
    int listen_fd;        // fd to wait for a new connection
} http_server;

typedef struct {
    int conn_fd;  // fd to talk with client
    int status;   // not used, error, reading (from client), writing (to client)

    char file[MAXBUFSIZE];   // requested file
    char query[MAXBUFSIZE];  // requested query
    char host[MAXBUFSIZE];   // client host
    char* buf;               // data sent by/to client
    size_t buf_len;          // bytes used by buf
    size_t buf_size;         // bytes allocated for buf
    size_t buf_idx;          // offset for reading and writing
} http_request;

static char* logfilenameP;  // log file name
static void set_ndelay(int fd);
static void sig_handler(int signo);
static void init_http_server(
    http_server* svrP,
    unsigned short port);  // initailize a http_request instance, exit for error
static void init_request(
    http_request* reqP);  // initailize a http_request instance
static void free_request(
    http_request* reqP);  // free resources used by a http_request instance
static int read_header_and_file(http_request* reqP, int* errP);
/*  return 0: success, file is buffered in retP->buf with retP->buf_len bytes
    return -1: error, check error code (*errP)
    return 1: continue to it until return -1 or 0
    error code:
    1: client connection error
    2: bad request, cannot parse request
    3: method not implemented
    4: illegal filename
    5: illegal query
    6: file not found
    7: file is protected  */

typedef struct {
    char timeInfo[128];
    char fileInfo[128];
} MapInfo;
MapInfo* map;
int mapfd;

int died = 0;
pid_t pid = 0;
int running_pid[20000] = {0};
char info[1024];

int main(int argc, char** argv) {
    http_server server;             // http server
    http_request* requestP = NULL;  // pointer to http requests from client

    int maxfd;                   // size of open file descriptor table
    struct sockaddr_in cliaddr;  // used by accept()
    int clilen;

    int conn_fd;  // fd for a new connection with client
    int err;      // used by read_header_and_file()
    int i, ret, nwritten;

    init_http_server(&server,
                     (unsigned short)atoi(argv[1]));  // Initialize http server

    maxfd = getdtablesize();
    requestP = (http_request*)malloc(sizeof(http_request) * maxfd);
    if (requestP == (http_request*)0)
        ERR_EXIT("out of memory allocating all http requests\n")

    for (i = 0; i < maxfd; i++) init_request(&requestP[i]);
    requestP[server.listen_fd].conn_fd = server.listen_fd;
    requestP[server.listen_fd].status = READING;

    fprintf(stderr,
            "starting on %.80s, port %d, fd %d, maxconn %d, logfile %s...\n",
            server.hostname, server.port, server.listen_fd, maxfd,
            logfilenameP);

    fd_set master;   /* master file descriptor list */
    fd_set read_fds; /* temp file descriptor list for select() */
    FD_ZERO(&master);
    FD_ZERO(&read_fds);
    FD_SET(server.listen_fd, &master);

    // int fdmax = server.listen_fd;
    while (1) { /* Main loop */
        read_fds = master;

        if (select(128, &read_fds, NULL, NULL, NULL) == -1) ERR_EXIT("select")

        for (i = 0; i < 128; i++) {
            if (FD_ISSET(i, &read_fds)) {
                if (i == server.listen_fd) {
                    clilen = sizeof(cliaddr);
                    conn_fd =
                        accept(server.listen_fd, (struct sockaddr*)&cliaddr,
                               (socklen_t*)&clilen);
                    if (conn_fd < 0) {
                        if (errno == EINTR || errno == EAGAIN)
                            continue;  // try again
                        if (errno == ENFILE) {
                            (void)fprintf(stderr,
                                          "out of file descriptor table ... "
                                          "(maxconn %d)\n",
                                          maxfd);
                            continue;
                        }
                        ERR_EXIT("accept")
                    }
                    requestP[conn_fd].conn_fd = conn_fd;
                    requestP[conn_fd].status = READING;
                    strcpy(requestP[conn_fd].host, inet_ntoa(cliaddr.sin_addr));
                    set_ndelay(conn_fd);
                    FD_SET(conn_fd, &master);
                    // if (conn_fd > fdmax)
                    //     fdmax = conn_fd;
                    fprintf(stderr, "getting a new request... fd %d from %s\n",
                            conn_fd, requestP[conn_fd].host);
                } else { /* Handle data from a client */
                    ret = read_header_and_file(&requestP[i], &err);
                    if (ret == 1)
                        continue;
                    else if (ret < 0) {
                        fprintf(stderr, "Error on fd %d, error code: %d\n",
                                requestP[i].conn_fd, err);
                        fprintf(stderr, "%s\n", requestP[i].buf);
                        fprintf(stderr, "%zu\n", requestP[i].buf_len);
                        switch (err) {
                            case 1: {
                                static char* msg =
                                    "HTTP/1.1 401 Unauthorized\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Unauthorized</h1>\n"
                                    "  <p>client connection error</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 2: {
                                static char* msg =
                                    "HTTP/1.1 400 Bad Request\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Bad Request</h1>\n"
                                    "  <p>bad request, cannot parse "
                                    "request</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 3: {
                                static char* msg =
                                    "HTTP/1.1 405 Method Not Allowed\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Method Not Allowed</h1>\n"
                                    "  <p>method not implemented</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                ;
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 4: {
                                static char* msg =
                                    "HTTP/1.1 400 Bad Request\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Bad Request</h1>\n"
                                    "  <p>illegal filename</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 5: {
                                static char* msg =
                                    "HTTP/1.1 400 Bad Request\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Bad Request</h1>\n"
                                    "  <p>illegal query</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 6: {
                                static char* msg =
                                    "HTTP/1.1 404 Not Found\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Not Found</h1>\n"
                                    "  <p>file not found</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            case 7: {
                                static char* msg =
                                    "HTTP/1.1 400 Bad Request\n"
                                    "Content-type: text/html; "
                                    "charset=iso-8859-1\n"
                                    "\n"
                                    "<html>\n"
                                    " <body>\n"
                                    "  <h1>Bad Request</h1>\n"
                                    "  <p>file is protected</p>\n"
                                    " </body>\n"
                                    "</html>\n";
                                write(requestP[i].conn_fd, msg, strlen(msg));
                                break;
                            }
                            default:
                                write(requestP[i].conn_fd, "???", 3);
                                break;
                        }
                        fprintf(
                            stderr,
                            "=============================================\n");
                        close(requestP[i].conn_fd);
                        free_request(&requestP[i]);
                        FD_CLR(conn_fd, &master);
                        break;
                    } else if (ret == 0) {
                        pid_t pid_info;
                        /* Show info */
                        if (!strncmp(requestP[i].file, "info", 4)) {
                            /* Dismiss the "SIGCHLD" before fork */
                            if (signal(SIGCHLD, SIG_IGN) == SIG_ERR)
                                ERR_EXIT("signal:SIGCHLD");

                            /* Register the "SIGUSR1" before fork */
                            if (signal(SIGUSR1, sig_handler) == SIG_ERR)
                                ERR_EXIT("signal:SIGUSR1")

                            if ((pid_info = fork()) < 0)
                                ERR_EXIT("fork")
                            else if (pid_info > 0) { /* parent */
                                // sleep(2);              /* Without sleeping,
                                // there is some select() error */
                                wait(NULL);
                            } else { /* child */
                                kill(getppid(), SIGUSR1);
                                exit(0);
                            }

                            fprintf(stderr, "INFO CONTENT:\n%s\n", info);
                            nwritten = write(
                                requestP[i].conn_fd, info,
                                strlen(info)); /* Write the info to client */
                            fprintf(stderr,
                                    "complete writing %d bytes on fd %d\n",
                                    nwritten, requestP[i].conn_fd);
                            fprintf(stderr,
                                    "=========================================="
                                    "===\n");
                        } else {
                            /* Make a pipe before fork() */
                            int fd1[2], fd2[2];
                            // for (int i = 0; i < 2; i++) {
                            //     int flags1 = fcntl(fd1[i], F_GETFL, 0);
                            //     fcntl(fd1[i], F_SETFL, flags1 | O_NONBLOCK);
                            //     int flags2 = fcntl(fd2[i], F_GETFL, 0);
                            //     fcntl(fd2[i], F_SETFL, flags2 | O_NONBLOCK);
                            // }

                            if (pipe(fd1) == -1) ERR_EXIT("pipe error: fd1")
                            if (pipe(fd2) == -1) ERR_EXIT("pipe error: fd2")

                            /* Register a "SIGCHLD" before fork */
                            if (signal(SIGCHLD, sig_handler) == SIG_ERR)
                                ERR_EXIT("signal:SIGCHLD");

                            /* Init Map */
                            if ((mapfd = open("info.txt",
                                              O_RDWR | O_TRUNC | O_CREAT,
                                              0777)) < 0)
                                ERR_EXIT("open")
                            lseek(mapfd, sizeof(MapInfo), SEEK_SET);
                            write(mapfd, "", 1);
                            map = (MapInfo*)mmap(0, sizeof(MapInfo),
                                                 PROT_READ | PROT_WRITE,
                                                 MAP_SHARED, mapfd, 0);
                            close(mapfd);

                            if ((pid = fork()) < 0)
                                ERR_EXIT("fork error")
                            else if (pid > 0) { /* parent */
                                close(fd1[0]);
                                close(fd2[1]);

                                if (write(fd1[1], requestP[i].query,
                                          sizeof(requestP[i].query)) <
                                    0) /* Parent write to fd1[1] */
                                    ERR_EXIT("write error to pipe")

                                char recv[1024] = "";
                                if (read(fd2[0], recv, sizeof(recv)) <
                                    0) /* Parent read from fd2[0] */
                                    ERR_EXIT("read error from pipe")

                                nwritten = write(requestP[i].conn_fd, recv,
                                                 strlen(recv));
                                fprintf(stderr,
                                        "complete writing %d bytes on fd %d\n",
                                        nwritten, requestP[i].conn_fd);
                                fprintf(stderr,
                                        "======================================"
                                        "=======\n");
                                running_pid[pid] = ALIVE;

                                close(fd1[1]);
                                close(fd2[0]);
                                wait(NULL);
                            } else { /* child */
                                close(fd1[1]);
                                close(fd2[0]);
                                if (fd1[0] != STDIN_FILENO) {
                                    if (dup2(fd1[0], STDIN_FILENO) !=
                                        STDIN_FILENO)
                                        ERR_EXIT("dup2 error to stdin")
                                    close(fd1[0]);
                                }

                                if (fd2[1] != STDOUT_FILENO) {
                                    if (dup2(fd2[1], STDOUT_FILENO) !=
                                        STDOUT_FILENO)
                                        ERR_EXIT("dup2 error to stdout")
                                    close(fd2[1]);
                                }

                                if (execl(requestP[i].file, requestP[i].file,
                                          (char*)0) < 0)
                                    ERR_EXIT("execl error");
                            }
                        }
                        close(requestP[i].conn_fd);
                        free_request(&requestP[i]);
                        FD_CLR(conn_fd, &master);
                        break;
                    }
                }
            }
        }
    }
    free(requestP);
    return 0;
}
// ======================================================================================================
// You don't need to know how the following codes are working

static void add_to_buf(http_request* reqP, char* str, size_t len);
static void strdecode(char* to, char* from);
static int hexit(char c);
static char* get_request_line(http_request* reqP);
static void* e_malloc(size_t size);
static void* e_realloc(void* optr, size_t size);

static void init_request(http_request* reqP) {
    reqP->conn_fd = -1;
    reqP->status = 0;  // not used
    reqP->file[0] = (char)0;
    reqP->query[0] = (char)0;
    reqP->host[0] = (char)0;
    reqP->buf = NULL;
    reqP->buf_size = 0;
    reqP->buf_len = 0;
    reqP->buf_idx = 0;
}

static void free_request(http_request* reqP) {
    if (reqP->buf != NULL) {
        free(reqP->buf);
        reqP->buf = NULL;
    }
    init_request(reqP);
}

#define ERR_RET(error) \
    {                  \
        *errP = error; \
        return -1;     \
    }
// return 0: success, file is buffered in retP->buf with retP->buf_len bytes
// return -1: error, check error code (*errP)
// return 1: read more, continue until return -1 or 0
// error code:
// 1: client connection error
// 2: bad request, cannot parse request
// 3: method not implemented
// 4: illegal filename
// 5: illegal query
// 6: file not found
// 7: file is protected

static int read_header_and_file(http_request* reqP, int* errP) {
    char* file = (char*)0;
    char* path = (char*)0;
    char* query = (char*)0;
    char* protocol = (char*)0;
    char* method_str = (char*)0;
    int r, fd, fp;
    struct stat sb, file_stat;
    char timebuf[100];
    int buflen;
    char buf[10000];
    time_t now;
    void* ptr;

    // Read in request from client
    while (1) {
        r = read(reqP->conn_fd, buf, sizeof(buf));
        if (r < 0 && (errno == EINTR || errno == EAGAIN)) return 1;
        if (r <= 0) ERR_RET(1)
        add_to_buf(reqP, buf, r);
        if (strstr(reqP->buf, "\015\012\015\012") != (char*)0 ||
            strstr(reqP->buf, "\012\012") != (char*)0)
            break;
    }
    fprintf(stderr, "---------------------------------------------\n");

    // Parse the first line of the request.
    method_str = get_request_line(reqP);
    if (method_str == (char*)0) ERR_RET(2)
    path = strpbrk(method_str, " \t\012\015");
    if (path == (char*)0) ERR_RET(2)
    *path++ = '\0';
    path += strspn(path, " \t\012\015");
    protocol = strpbrk(path, " \t\012\015");
    if (protocol == (char*)0) ERR_RET(2)
    *protocol++ = '\0';
    protocol += strspn(protocol, " \t\012\015");
    query = strchr(path, '?');
    if (query == (char*)0)
        query = "";
    else
        *query++ = '\0';

    if (strcasecmp(method_str, "GET") != 0)
        ERR_RET(3)
    else {
        strdecode(path, path);
        if (path[0] != '/')
            ERR_RET(4)
        else
            file = &(path[1]);
    }

    if (strlen(file) >= MAXBUFSIZE - 1) ERR_RET(4)
    if (strlen(query) >= MAXBUFSIZE - 1) ERR_RET(5)
    strcpy(reqP->file, file);
    strcpy(reqP->query, query);

    /* The file is "info" and query is empty */
    if (!strcmp(file, "info")) {
        if (!strcmp(query, ""))
            return 0;
        else
            ERR_RET(2)
    }

    /* Check whether the CGI file is invalid or not */
    int invalid = 0;
    for (int i = 0; i < strlen(file); i++)
        if (!(isdigit(file[i]) || isalpha(file[i]) || file[i] == '_')) {
            invalid = 1;
            ERR_RET(4)
        }

    /* Get the stat of the CGI file */
    fprintf(stderr, "reqP->file = %s\n", reqP->file);
    if ((fp = stat(reqP->file, &file_stat)) < 0) ERR_RET(6)

    /* The name of filename is correct */
    if (!strncmp(query, "filename=", 9)) {
        char* m = strchr(reqP->query, '=') + 1;
        char* filename = strncpy(reqP->query, m, strlen(reqP->query));

        /* Check whether the filename is invalid or not */
        invalid = 0;
        for (int i = 0; i < strlen(filename); i++)
            if (!(isdigit(filename[i]) || isalpha(filename[i]) ||
                  filename[i] == '_')) {
                invalid = 1;
                fprintf(stderr, "filename[%d] = '%c', which is invalid\n", i,
                        filename[i]);
                ERR_RET(5)
            }

        /* Get the stat of the filename */
        if ((r = stat(filename, &sb)) < 0) ERR_RET(6)

        /* Open the filename in read-only mode */
        if ((fd = open(filename, O_RDONLY)) < 0) ERR_RET(7)

        reqP->buf_len = 0;

        buflen = snprintf(buf, sizeof(buf),
                          "HTTP/1.1 200 OK\015\012Server: SP TOY\015\012");
        add_to_buf(reqP, buf, buflen);
        now = time((time_t*)0);
        (void)strftime(timebuf, sizeof(timebuf), "%a, %d %b %Y %H:%M:%S GMT",
                       gmtime(&now));
        buflen = snprintf(buf, sizeof(buf), "Date: %s\015\012", timebuf);
        add_to_buf(reqP, buf, buflen);
        buflen = snprintf(buf, sizeof(buf), "Content-Length: %lld\015\012",
                          (int64_t)sb.st_size);
        add_to_buf(reqP, buf, buflen);
        buflen =
            snprintf(buf, sizeof(buf), "Connection: close\015\012\015\012");
        add_to_buf(reqP, buf, buflen);

        ptr = mmap(0, (size_t)sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
        if (ptr == (void*)-1) ERR_RET(8)
        add_to_buf(reqP, ptr, sb.st_size);
        (void)munmap(ptr, sb.st_size);
        close(fd);

        fprintf(stderr, "%s\n", reqP->buf);
        return 0;
    } else
        ERR_RET(2)

    fprintf(stderr,
            "(conn_fd, status, file, query, host) = (%d, %d, %s, %s, %s)\n",
            reqP->conn_fd, reqP->status, reqP->file, reqP->query, reqP->host);
    fprintf(stderr, "(buf, buf_len, buf_size, buf_idx) = (%s, %zu, %zu, %zu)\n",
            reqP->buf, reqP->buf_len, reqP->buf_size, reqP->buf_idx);
    fprintf(stderr, "---------------------------------------------\n");
    return 0;
}

static void add_to_buf(http_request* reqP, char* str, size_t len) {
    char** bufP = &(reqP->buf);
    size_t* bufsizeP = &(reqP->buf_size);
    size_t* buflenP = &(reqP->buf_len);

    if (*bufsizeP == 0) {
        *bufsizeP = len + 500;
        *buflenP = 0;
        *bufP = (char*)e_malloc(*bufsizeP);
    } else if (*buflenP + len >= *bufsizeP) {
        *bufsizeP = *buflenP + len + 500;
        *bufP = (char*)e_realloc((void*)*bufP, *bufsizeP);
    }
    (void)memmove(&((*bufP)[*buflenP]), str, len);
    *buflenP += len;
    (*bufP)[*buflenP] = '\0';
}

static char* get_request_line(http_request* reqP) {
    int begin;
    char c;

    char* bufP = reqP->buf;
    int buf_len = reqP->buf_len;
    for (begin = reqP->buf_idx; reqP->buf_idx < buf_len; ++reqP->buf_idx) {
        c = bufP[reqP->buf_idx];
        if (c == '\012' || c == '\015') {
            bufP[reqP->buf_idx] = '\0';
            ++reqP->buf_idx;
            if (c == '\015' && reqP->buf_idx < buf_len &&
                bufP[reqP->buf_idx] == '\012') {
                bufP[reqP->buf_idx] = '\0';
                ++reqP->buf_idx;
            }
            return &(bufP[begin]);
        }
    }
    fprintf(stderr, "http request format error\n");
    exit(1);
}

static void init_http_server(http_server* svrP, unsigned short port) {
    struct sockaddr_in servaddr;
    int tmp;
    gethostname(svrP->hostname, sizeof(svrP->hostname));
    svrP->port = port;
    svrP->listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (svrP->listen_fd < 0) ERR_EXIT("socket")
    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons(port);
    tmp = 1;
    if (setsockopt(svrP->listen_fd, SOL_SOCKET, SO_REUSEADDR, (void*)&tmp,
                   sizeof(tmp)) < 0)
        ERR_EXIT("setsockopt ")
    if (bind(svrP->listen_fd, (struct sockaddr*)&servaddr, sizeof(servaddr)) <
        0)
        ERR_EXIT("bind")
    if (listen(svrP->listen_fd, 1024) < 0) ERR_EXIT("listen")
}

static void set_ndelay(int fd) {  // Set NDELAY mode on a socket.
    int flags, newflags;
    flags = fcntl(fd, F_GETFL, 0);
    if (flags != -1) {
        newflags = flags | (int)O_NDELAY;  // nonblocking mode
        if (newflags != flags) (void)fcntl(fd, F_SETFL, newflags);
    }
}

static void strdecode(char* to, char* from) {
    for (; *from != '\0'; ++to, ++from) {
        if (from[0] == '%' && isxdigit(from[1]) && isxdigit(from[2])) {
            *to = hexit(from[1]) * 16 + hexit(from[2]);
            from += 2;
        } else {
            *to = *from;
        }
    }
    *to = '\0';
}

static int hexit(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return 0;  // shouldn't happen
}

static void* e_malloc(size_t size) {
    void* ptr;
    ptr = malloc(size);
    if (ptr == (void*)0) {
        (void)fprintf(stderr, "out of memory\n");
        exit(1);
    }
    return ptr;
}

static void* e_realloc(void* optr, size_t size) {
    void* ptr;
    ptr = realloc(optr, size);
    if (ptr == (void*)0) {
        (void)fprintf(stderr, "out of memory\n");
        exit(1);
    }
    return ptr;
}

static void sig_handler(int signo) {
    if (signo == SIGCHLD) {
        fprintf(stderr, "Get SIGCHLD!\n");
        // wait(NULL);
        running_pid[pid] = DIED;
        died++;
    }
    if (signo == SIGUSR1) {
        fprintf(stderr, "Get SIGUSR1!\n");
        wait(NULL);
        sprintf(
            info,
            "%d processes died previously.\nPIDs of Running Processes:", died);

        int j = 0;            // The number of running processes
        char pidBuf[20][10];  // Assume there is at most 20 processes running
        memset(pidBuf, 0, sizeof(pidBuf));
        for (int i = 0; i < 20000; i++)
            if (running_pid[i] == ALIVE) {
                fprintf(stderr, "running_pid[%d] = ALIVE\n", i);
                sprintf(pidBuf[j], "%d", i);
                j++;
            }

        for (int i = 0; i < j; i++) {
            if (i == j - 1) {
                strncat(info, " ", 1);
                strncat(info, pidBuf[i], strlen(pidBuf[i]));
                break;
            }
            strncat(info, " ", 1);
            strncat(info, pidBuf[i], strlen(pidBuf[i]));
            strncat(info, ",", 1);
        }

        strncat(info, "\nLast Exit CGI: ", 16);

        mapfd = open("info.txt", O_RDWR, 0777);
        fprintf(stderr, "timeInfo = %s\n", map->timeInfo);
        strncat(info, map->timeInfo, strlen(map->timeInfo) - 1);

        strncat(info, ", filename: ", 12);
        strncat(info, map->fileInfo, strlen(map->fileInfo));
    }
}