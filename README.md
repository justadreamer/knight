# chess knight
Investigating the board coverage by a chess knight.  A board coverage means that a knight has to start at (0,0) (top right corner) and visit each cell exactly once, forming a (Hamiltonian) path.  Program outputs a board, with each cell marked by a position index of that cell in the knight's path.

## usage
Use `knight.swift` - the command line program.  It takes the dimensions of the board as params. Playground works awfully slow on any non-trivial board, and is not up to date.  All in all program works awfully slow on any square board of size 6x6+.  Rectangular boards for some reason are processed faster.  Looking for ways to optimize it, but without using any heuristics - just plain DFS in iterative manner with backtracking.  

## DFS with backtracking vs. bruteforce search
DFS (5^(M*N)) is obviously much faster than any bruteforce search (just checking each permutation of cells (M*N)!), but still is expnential and thus very slow.  But obvioiusly this is Hamiltonian path, humanity does not know a polynomial time algo to solve it (otherwise P==NP). 

```
➜ swift knight.swift 3 4
 1  4  7 10
12  9  2  5
 3  6 11  8
```

```
➜ swift knight.swift 4 5
 1 14  5 18  7
10 19  8 13  4
15  2 11  6 17
20  9 16  3 12
```

```
➜ swift knight.swift 5 6
 1 28 13 22 17 30
14 23 16 29 12 21
27  2 25 18  9  6
24 15  4  7 20 11
 3 26 19 10  5  8
```

```
➜ swift knight.swift 6 7
 1 32 39 36 25 30 27
40 35 22 31 28 37 24
21  2 33 38 23 26 29
34 41 14 17  6 11  8
15 20  3 12  9 18  5
42 13 16 19  4  7 10
```

```
➜ swift knight.swift 7 8
 1 30 47 50 33 28 45 42
48 51 32 29 46 43 24 27
31  2 49 34 25 22 41 44
52 55 36 21 40 13 26 23
37 18  3 54 35 10  7 12
56 53 16 39 20  5 14  9
17 38 19  4 15  8 11  6
```
