#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE SUJIKO
# ----------------------------------------

# The aim of Sujiko is to fill the 3x3 grid with the numbers 1-9 so that the given circled numbers
# (located at points where the cells meet) are equal to the sums of the numbers in surrounding cells.
# This puzzle appears in the Daily Telegraph newspaper.

# Written by Joe Bloggs [2017-09-06 Wed]

option solver gecode;

# cell & circle indices
set ind1 := 1..3;
set ind2 := 1..2;

# given[i,j] > 0 is the value given for row i, col j
# given[i,j] = 0 means no value given
param given{ind1, ind1}, integer, in 0..9;
param circled{ind2, ind2}, integer, in 4..36;

# X[i,j] = the number assigned to the cell in row i, col j
var X {ind1, ind1} integer, in 1..9;

# assign given values
subject to AssignGiven{i in ind1, j in ind1: given[i,j] > 0}:
	X[i,j] = given[i,j];

# all cell numbers should be different
subject to DiffCells: alldiff{i in ind1, j in ind1} X[i,j];

# circled values should equal sum of surrounding squares
subject to CircledSums{i in ind2, j in ind2}:
	X[i,j] + X[i+1,j] + X[i,j+1] + X[i+1,j+1] = circled[i,j];

# fixed values (change these to fit the particular puzzle being solved)
data;
param given default 0 :
  1 2 3 :=
1 . . . 
2 . . . 
3 . . 4 ;

param circled :
  1  2 :=
1 26 15
2 23 22 ;

solve;

# display the results
for {i in ind1} {
  for {j in ind1} {
      printf "%3i", X[i,j];
  }
  printf "\n";
}
