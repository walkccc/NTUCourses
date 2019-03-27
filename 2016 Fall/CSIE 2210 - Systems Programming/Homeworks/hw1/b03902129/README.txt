I put the "Makefile" and the "server.c" in the b03902129 folder.

First, I declare 2 variables set and tempest, whose type is fd_set, then FD_ZERO() both of them. And I also declare a lock of type struct flock.

In the while-loop, I FD_SET() the svr.listen_fd in the set to be 1 to ensure that the data of set will not crash. I copy them to tmpset(that’s why we need 2 fd_set).

Then I implement the select() function to make sure svr.listen is prepared for accepting other clients’ connection and the clients which is already connected, and add the file descriptor of them to do select().

READ_SERVER:
Use lock to determine whether there is a file written in WRITE_SERVER, if it is yes, then cut the connection, else print the file’s contents.

WRITE_SERVER:
It’s similar to READ_SERVER but a little bit different, since if someone reads or writes, others cannot write the file. If there is a lock, then the connection is cut, else write the file if it exists or O_CREAT it then write it.