I put the “Makefile”, the “server.c” and the “file_reader.c” in the “b03902129” folder.

First, I initialize a server by “./server [port_num]”. I omit the logfilename part since it won’t be used in this homework.

I declare 2 variables master and read_fds, whose type is fd_set, then FD_ZERO() both of them.

In the while-loop, I FD_SET() the server.listen_fd in the master to be 1 to ensure that the data of the set will not crash. I then copy them to read_fds(that’s why we need 2 fd_set.)

Then I implement the select() function to make sure server.listen_fd is prepared for accepting other clients’ connection and the clients which is already connected, and add the file descriptor of them to master for the select().

When the for-loop enter the else part, it will handle data from a client. We use a variable “ret” to decide what we should do next. 
1. ret < 0: show some error message to the client(browser).
2. ret == 0: (use pipe as the media)
  (a) show some info to the client(browser) by using “kill(getppid(), SIGUSR1);” in the child process we forked.
  (b) run the file_reader to read the file for the client, and update the last CGI exit time and filename by mmap(), and finally show the content of the file to the client. Use SIGCHLD to record the number of dead processes.
