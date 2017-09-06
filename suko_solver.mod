#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE SUKO
# ----------------------------------------

# Written by Joe Bloggs [2017-09-06 Wed], vapniks@yahoo.com

# Use gecode solver so we can use constraint programming extensions (alldiff)
option solver gecode;

# VARIABLES
# X[i,j] = the number assigned to the cell in row i, col j
var X {1..3, 1..3} integer, in 1..9;

# CONSTRAINTS (from 4/5/2016 issue of The Times newspaper, page 4)

# make sure all numbers are different
subject to distinct: alldiff{i in 1..3, j in 1..3} X[i,j];
# subsquare sums
subject to sum4: X[1,1] + X[1,2] + X[2,1] + X[2,2] = 24;
subject to sum5: X[2,1] + X[2,2] + X[3,1] + X[3,2] = 24;
subject to sum6: X[1,2] + X[1,3] + X[2,2] + X[2,3] = 16;
subject to sum7: X[2,2] + X[2,3] + X[3,2] + X[3,3] = 18;
# extra sums
subject to sum1: X[3,1] + X[3,3] = 9;
subject to sum2: X[2,2] + X[2,3] + X[3,2] = 15;
subject to sum3: X[1,1] + X[1,2] + X[1,3] + X[2,1] = 21;

# SOLVE THE PUZZLE
solve;

# DISPLAY THE RESULTS
printf "+---+---+---+\n";
for {i in 1..3} {
  printf "|";
  for {j in 1..3} {
      printf "%2i |", X[i,j];
  }
  printf "\n+---+---+---+\n";  
}

