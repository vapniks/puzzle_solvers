#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE SUJIKO
# ----------------------------------------

# The aim of Suguru is to fill the 5x5 grid so that no same digit appears in neighbouring cells
# (not even diagonally), and so that an outlined region of N cells contains all the integers 1 to N.
# This puzzle appears in the Daily Telegraph newspaper.

# Written by Joe Bloggs [2017-09-06 Wed]

option solver gecode;

# cell indices
set ind1 := 1..5;
set ind2a := 2..5;
set ind2b := 1..4;

# given[i,j] > 0 is the value given for row i, col j
# given[i,j] = 0 means no value given
param given{ind1, ind1}, integer, in 0..25;
# total number of regions
param numregions;
# region[i,j] = region number for i,j entry of grid
param region{ind1, ind1};
# X[i,j] = the number assigned to the cell in row i, col j
var X{ind1, ind1} integer, in 1..25;
# regionsize[r] = number of cells in region r (this will be calculated so you dont have to specify it).
var regionsize{1..numregions} integer, in 1..25;

# Constraints

# assign given values
subject to AssignGiven{i in ind1, j in ind1: given[i,j] > 0}:
	X[i,j] = given[i,j];

# Numbers in neighbouring cells should be different.
subject to DiffCellsUp{i in ind2a, j in ind1}: X[i,j] != X[i-1,j];
subject to DiffCellsDown{i in ind2b, j in ind1}: X[i,j] != X[i+1,j];
subject to DiffCellsLeft{i in ind1, j in ind2a}: X[i,j] != X[i,j-1];
subject to DiffCellsRight{i in ind1, j in ind2b}: X[i,j] != X[i,j+1];
subject to DiffCellsDownRight{i in ind2b, j in ind2b}: X[i,j] != X[i+1,j+1];
subject to DiffCellsDownLeft{i in ind2b, j in ind2a}: X[i,j] != X[i+1,j-1];
subject to DiffCellsUpRight{i in ind2a, j in ind2b}: X[i,j] != X[i-1,j+1];
subject to DiffCellsUpLeft{i in ind2a, j in ind2a}: X[i,j] != X[i-1,j-1];

# Calculate region sizes
subject to Sizes{r in 1..numregions}:
	regionsize[r] = sum{i in ind1, j in ind1: region[i,j] = r} 1;
# Regions of size N should contain digits 1 to N.
subject to RegionsAlldiff{r in 1..numregions}:
	alldiff{i in ind1, j in ind1: region[i,j] = r} X[i,j];
subject to RegionsMax{r in 1..numregions}:
	regionsize[r] = max{i in ind1, j in ind1: region[i,j] = r} X[i,j];

# fixed values (change these to fit the particular puzzle being solved)
data;
# given values
param given default 0 :
  1 2 3 4 5 :=
1 . 5 . . 1
2 . . . . .
3 3 . . . .
4 . . 1 . .
5 1 . . . .
;

# total number of regions
param numregions := 6;
# region[i,j] = region number for i,j entry of grid
param region:
   1 2 3 4 5 :=
1  1 1 3 5 5
2  1 1 3 6 6
3  2 1 3 6 6
4  2 2 3 4 6
5  2 2 4 4 4
;

solve;

# display the results
for {i in ind1} {
  for {j in ind1} {
      printf "%3i", X[i,j];
  }
  printf "\n";
}
