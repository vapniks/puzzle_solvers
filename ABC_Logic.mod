#!/usr/bin/env ampl
# ---------------------------------------------------------------
# AMPL MODEL TO SOLVE "ABC LOGIC" PUZZLE IN INDEPENDENT NEWSPAPER
# ---------------------------------------------------------------

# The aim of this puzzle is to fill each row and column of a 5x5 grid with the letters A, B & C and two X's
# Some letters (excluding X) are written around the outside of the grid at the starts and ends of some rows and columns.
# These letters around the outside indicate the first or last letter which should appear within the corresponding row or column
# that the outer letter is next to.
# This puzzle appears in the Independent newspaper.

# Written by Joe Bloggs [2017-09-06 Wed]

option solver gecode;

# number of rows/columns
param n := 5;

# different letters (1 & 2 = blank, 3 = A, 4 = B, 5 = C)
set letters := 1..n;

# left/right/top/bottom letters
param leftletter{1..n} in letters;
param rightletter{1..n} in letters;
param topletter{1..n} in letters;
param bottomletter{1..n} in letters;

# X[i,j] assigned to ith row and jth column of solution
var X{1..n,1..n} in letters;

# CONSTRAINTS

# letters in each row are all different
subject to rows{i in 1..n}: alldiff{j in 1..n} X[i,j];
# letters in each column are all different
subject to cols{j in 1..n}: alldiff{i in 1..n} X[i,j];

# left/right/top/bottom-most letter is correct
subject to left{i in 1..n, j in 1..n, k in 1..j-1: leftletter[i] > 2}:
	((X[i,j] = leftletter[i]) and (X[i,k] <= 2)) or (not (X[i,j] = leftletter[i])) ;
subject to right{i in 1..n, j in 1..n, k in j+1..n: rightletter[i] > 2}:
	((X[i,j] = rightletter[i]) and (X[i,k] <= 2)) or (not (X[i,j] = rightletter[i])) ;
subject to top{i in 1..n, j in 1..n, k in 1..i-1: topletter[j] > 2}:
	((X[i,j] = topletter[j]) and (X[k,j] <= 2)) or (not (X[i,j] = topletter[j])) ;
subject to bottom{i in 1..n, j in 1..n, k in i+1..n: bottomletter[j] > 2}:
	((X[i,j] = bottomletter[j]) and (X[k,j] <= 2)) or (not (X[i,j] = bottomletter[j])) ;

# FIXED VALUES
data;
param leftletter :=
1 1
2 4
3 5
4 1
5 4;
param rightletter :=
1 5
2 1
3 1
4 3
5 5;
param topletter :=
1 1
2 4
3 3
4 5
5 4;
param bottomletter :=
1 5
2 3
3 1
4 1
5 1;

solve;

# DISPLAY RESULTS
printf "+-----------+----\n";
for {i in 1..n} {
  printf "|";
  for {j in 1..n} {
      printf "%3i", X[i,j];
  }
  printf "\n";
}
