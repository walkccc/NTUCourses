To start the program:
	'bash ./hw2.sh'
	then type the number of pigeons and holes.

The number in the output file 'output.txt' is calculated as follows:
	num = (pigeon.index - 1) * len(holes) + hole.index

To get the <pigeon.index> and <hole.index> from <num>: 
	1. pigeon.index = (num / m) + 1
	2. hole.index = num % m

For example: if n = 6, m = 9, num = 43
	1. pigeon.index = (43 / 9) + 1 = 5
	2. hole.index = 43 % 9 = 7
	which means that pigeon[5] lives in the hole[7] (indexing from 1)