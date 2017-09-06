#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE SUDOKARROW
# ----------------------------------------

# Written by Joe Bloggs [2017-09-06 Wed], vapniks@yahoo.com

# Use gecode solver so we can use constraint programming extensions (alldiff)
option solver gecode;

# PARAMETERS & VARIABLES

# parameters specifying size of grid
param m default 3, >= 1, integer ;
# size of each square
param maxdigit := m*m;
# total number of different digits
set digits := 1..maxdigit;
# known[i,j] > 0 is the value given for row i, col j
# known[i,j] = 0 means no value given
param known{digits, digits}, integer, in 0..maxdigit;
# total number of arrows
param numarrows;
set arrownum := 1..numarrows;
# arrow[i,j] = arrow number for i,j entry of grid (or 0 if there is no arrow at i,j)
param arrow{digits, digits};
# arrowhead[i,j] = arrow number when i,j is head of an arrow (0 otherwise)
param arrowhead{digits,digits};
# X[i,j] = the number assigned to the cell in row i, col j
var X {digits, digits} integer, in digits;

# CONSTRAINTS

# assign known values
subject to AssignKnown{i in digits, j in digits: known[i,j] > 0}:
	X[i,j] = known[i,j];

# cells in the same row must be assigned distinct numbers
subject to Rows{i in digits}:
	alldiff{j in digits} X[i,j];

# cells in the same column must be assigned distinct numbers
subject to Cols{j in digits}:
	alldiff{i in digits} X[i,j];

# cells in the same box must be assigned distinct numbers
subject to Boxes{I in 1..maxdigit by 3, J in 1..maxdigit by 3}:
	alldiff{i in I..I+2, j in J..J+2} X[i,j];

# cells in each arrow must sum to 2 x arrowhead
subject to Arrows{r in arrownum}:
	sum{i in digits, j in digits: arrow[i,j] = r} X[i,j] = 2*sum{i in digits, j in digits: arrowhead[i,j] = r} X[i,j];

# DATA
data;
# known values
param known default 0 :
  1 2 3 4 5 6 7 8 9 :=
1 . . . . . . . . .
2 . . . 4 . . . . .
3 . . . . . . . . .
4 . . 7 . . 6 . . .
5 . . . . . . . . .
6 . . . 7 . . 6 . .
7 . . . . . . . . .
8 . . . . . 4 . . .
9 . . . . . . . . . ;
# total number of arrows
param numarrows := 17;
# arrow[i,j] = arrow number for i,j entry of grid (includes arrow heads)
param arrow default 0 :
    1  2  3  4  5  6  7  8  9 :=
1   1  .  2  3  3 16 16 16 13
2   1  1  3  2  . 15  . 13 16
3   .  1  .  4  2 15 14  . 13
4   5  5  4  .  2 11 15 14  .
5   .  5  4  2 11  .  . 14 12
6   6  .  . 17 11 10 10 14 12
7   6  6 17  8  9 10 14  . 12
8   . 17  8  8  .  9  .  .  .
9   7  7  7  .  .  9  9  .  .  ;

# arrowhead[i,j] = arrow number if i,j entry is an arrow head
param arrowhead default 0 :
    1  2  3  4  5  6  7  8  9 :=
1   1  .  2  .  . 16  .  .  .
2   .  .  3  .  . 15  .  .  .
3   .  .  .  4  .  . 14  . 13
4   .  5  .  .  . 11  .  .  .
5   .  .  .  .  .  .  .  . 12
6   .  .  .  17 . 10  .  .  .
7   .  6  .  8  9  .  .  .  .
8   .  .  .  .  .  .  .  .  . 
9   7  .  .  .  .  .  .  .  . ;

# SOLVE THE PUZZLE
solve;

# DISPLAY THE RESULTS
printf "+-----------+-----------+-----------+\n";
for {i in digits} {
  printf "|";
  for {j in digits} {
      printf "%3i", X[i,j];
      if ((j mod m) == 0) then {printf "  |"} else {printf ""};
  }
  if ((i mod m) == 0) then {printf "\n+-----------+-----------+-----------+"} else {printf ""};
  printf "\n";
}
