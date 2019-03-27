big_judge.c:
First I convert the judge_num & player_num to integer, then I make pipes between each judge with the big_judge. Then I fork [judge_num]’s child processes, and redirect the stdin to let judge read from it, and redirect the stdout to let judge write to it, then execute the "judge" program in the specific argument(./judge [judge_id]).

In the parent process, I simply close the useless fds.
	
Then I assign C(player_num, 4) competitions to a list.
In the while loop, I assign each judge 4 players, and keep them busy by using the select() function.

After adding all the scores, I sort and print the result.


judge.c
First I scan the 4 players’ ID, then make 5 FIFOs for opening them(1 for write and 4 for read), then fork() 4 child processes to execute the "player" program in the specific argument(./player [judge_id] [player_index] [random_key]).

It then starts the 20 rounds game, each time I read the 4 numbers sent from the players and then write the 4 numbers to the judge[judge_id].FIFO to enable the 4 players to read from it.

Then write the accumulate score to the big_judge.
Finally, wait the zombie processes and unlink the FIFOs.


player.c

Each player first open the specific FIFOs(1 for reading and 1 for writing), my program is stupid, so I send the judge {1, 3, 3, 5} for players{"A", "B", "C", "D"} each times.
Finally fclose() the fds.