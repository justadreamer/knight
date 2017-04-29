# chess knight
Investigating the board coverage by a chess knight.  A board coverage means that a knight has to start at (0,0) (top right corner) and visit each cell exactly once, forming a (Hamiltonian) path.  Program outputs a board, with each cell marked by a position index of that cell in the knight's path.

## usage
Either compile directly:

```
swiftc knight.playground/Sources/knight.swift main.swift -o knight
```

or run 

```
./snapshot-test.sh
```

it will create an executable `knight`, which you can then pass the board dimensions (can be rectangular). f.e.:

```
./knight 5 5
 1  6 15 10 21
14  9 20  5 16
19  2  7 22 11
 8 13 24 17  4
25 18  3 12 23
```


You can use playground, but it works awfully slow on any non-trivial board.  
All in all program works awfully slow on any square board of size 6x6+.  
Rectangular boards for some reason are processed faster.  Looking for ways to optimize it, 
but without using any heuristics - just plain DFS in iterative manner with backtracking.  

## DFS with backtracking vs. bruteforce search
DFS (5^(M*N)) is obviously much faster than any bruteforce search (just checking each permutation of cells (M*N)!), but still is expnential and thus very slow.  But obvioiusly this is Hamiltonian path, humanity does not know a polynomial time algo to solve it (otherwise P==NP). 

```
./knight 3 4
 1  4  7 10
12  9  2  5
 3  6 11  8
```

```
./knight 4 5
 1 14  5 18  7
10 19  8 13  4
15  2 11  6 17
20  9 16  3 12
```

```
./knight 5 6
 1 28 13 22 17 30
14 23 16 29 12 21
27  2 25 18  9  6
24 15  4  7 20 11
 3 26 19 10  5  8
```

```
./knight 6 7
 1 32 39 36 25 30 27
40 35 22 31 28 37 24
21  2 33 38 23 26 29
34 41 14 17  6 11  8
15 20  3 12  9 18  5
42 13 16 19  4  7 10
```

```
./knight 7 8
 1 30 47 50 33 28 45 42
48 51 32 29 46 43 24 27
31  2 49 34 25 22 41 44
52 55 36 21 40 13 26 23
37 18  3 54 35 10  7 12
56 53 16 39 20  5 14  9
17 38 19  4 15  8 11  6
```

```
./knight 5 5
 1  6 15 10 21
14  9 20  5 16
19  2  7 22 11
 8 13 24 17  4
25 18  3 12 23
```

```
./knight 6 6
 1 28 33 18 23 26
34 17 24 27 32 19
29  2 31 20 25 22
16 35 14 11  8  5
13 30  3  6 21 10
36 15 12  9  4  7
```

```
./knight 7 7
 1 38 31 48 45 36 43
30 49 40 37 42 33 46
39  2 29 32 47 44 35
28 19 26 41 34 15  6
25 22  3 16  7 12  9
18 27 20 23 10  5 14
21 24 17  4 13  8 11
```
