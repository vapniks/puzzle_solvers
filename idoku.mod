#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE IDOKO
# ----------------------------------------

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

# cells in the same box must be assigned distinct numbers
subject to Boxes{I in 1..9 by 3, J in 1..9 by 3}:
	alldiff{i in I..I+2, j in J..J+2} X[i,j];

# cells in the middle i must be assigned distinct numbers
subject to I:
	alldiff{(i,j) in {(2,5),(4,4),(4,5),(5,5),(6,5),(7,5),(8,5),(8,4),(8,6)}} X[i,j];

# fixed values
data;
param given default 0 :
  1 2 3 4 5 6 7 8 9 :=
1 . . . 5 3 . 6 . 4
2 . . 1 . . . . . .
3 . . 2 4 . . 1 . 5
4 1 . . . . . . . .
5 9 5 . . 6 . . 8 1
6 . . . . . . . . 2
7 2 . 7 . . 9 8 . .
8 . . . . . . 9 . .
9 8 . 5 . 7 4 . . . ;

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
