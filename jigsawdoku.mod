#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE JIGSAWDOKO
# ----------------------------------------

# Written by Joe Bloggs [2017-09-06 Wed], vapniks@yahoo.com

## BASIC CONSTRAINTS
option solver gecode;

# total number of different digits
set digits := 1..9;

# given[i,j] > 0 is the value given for row i, col j
# given[i,j] = 0 means no value given
param given{digits, digits}, integer, in 0..9;

# X[i,j] = the number assigned to the cell in row i, col j
var X {digits, digits} integer, in digits;

# assign given values
subject to AssignGiven{i in digits, j in digits: given[i,j] > 0}:
	X[i,j] = given[i,j];

# cells in the same row must be assigned distinct numbers
subject to Rows{i in digits}:
	alldiff{j in digits} X[i,j];

# cells in the same column must be assigned distinct numbers
subject to Cols{j in digits}:
	alldiff{i in digits} X[i,j];

## REGIONS

# cells in each region must be assigned distinct numbers
subject to R1: alldiff{(i,j) in {(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(4,1)}} X[i,j];
subject to R2: alldiff{(i,j) in {(4,2),(4,3),(4,4),(5,1),(5,2),(5,3),(6,2),(7,2),(7,3)}} X[i,j];
subject to R3: alldiff{(i,j) in {(6,1),(7,1),(8,1),(8,2),(8,3),(8,4),(9,1),(9,2),(9,3)}} X[i,j];
subject to R4: alldiff{(i,j) in {(1,4),(1,5),(1,6),(2,4),(2,5),(3,3),(3,4),(3,5),(4,5)}} X[i,j];
subject to R5: alldiff{(i,j) in {(3,6),(4,6),(4,7),(5,4),(5,5),(5,6),(6,3),(6,4),(7,4)}} X[i,j];
subject to R6: alldiff{(i,j) in {(6,5),(7,5),(7,6),(7,7),(8,5),(8,6),(9,4),(9,5),(9,6)}} X[i,j];
subject to R7: alldiff{(i,j) in {(1,7),(1,8),(1,9),(2,6),(2,7),(2,8),(2,9),(3,9),(4,9)}} X[i,j];
subject to R8: alldiff{(i,j) in {(3,7),(3,8),(4,8),(5,7),(5,8),(5,9),(6,6),(6,7),(6,8)}} X[i,j];
subject to R9: alldiff{(i,j) in {(6,9),(7,8),(7,9),(8,7),(8,8),(8,9),(9,7),(9,8),(9,9)}} X[i,j];

# FIXED VALUES
data;
param given default 0 :
  1 2 3 4 5 6 7 8 9 :=
1 . . . 9 . . 3 . .
2 . . . . . . . . 9
3 . . . . 1 . . . .
4 3 . 4 6 . . 2 . .
5 7 3 . 5 . . . 1 2
6 . . . 1 2 . 4 . .
7 . . 2 . . . . . .
8 . . 5 . . . . . .
9 . . 1 . . 7 5 . . ;

solve;

# display the results
printf "+-----------+-----------+-----------+\n";
for {i in digits} {
  printf "|";
  for {j in digits} {
      printf "%3i", X[i,j];
      if ((j mod 3) == 0) then {printf "  |"} else {printf ""};
  }
  if ((i mod 3) == 0) then {printf "\n+-----------+-----------+-----------+"} else {printf ""};
  printf "\n";
}
