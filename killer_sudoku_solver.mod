#!/usr/bin/env ampl
# ----------------------------------------
# AMPL MODEL TO SOLVE KILLER SUDOKO 
# ----------------------------------------

# Written by Joe Bloggs [2017-09-06 Wed]

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
# total number of regions
param numregions;
set regionnum := 1..numregions;
# region[i,j] = region number for i,j entry of grid
param region{digits, digits};
# region_sum[r] = sum of values in region r
param region_sum{1..numregions};
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

# cells in each region must sum to correct value
subject to Regions{r in regionnum}:
	region_sum[r] = sum{i in digits, j in digits: region[i,j] = r} X[i,j];

# DATA
data;
# known values
param known default 0 :
  1 2 3 4 5 6 7 8 9 :=
1 . . . . . . . . .
2 . . . . . . . . .
3 . . . . . . . . .
4 . . . . . . . . .
5 . . . . . . . . .
6 . . . . . . . . .
7 . . . . . . . . .
8 . . . . . . . . .
9 . . . . . . . . . ;
# total number of regions
param numregions := 25;
# region[i,j] = region number for i,j entry of grid
param region:
    1  2  3  4  5  6  7  8  9 :=
1   1  1  1  4  5  5  5  6  6 
2   2  2  4  4  7  9  9  9  6 
3   3  3  8  7  7  9  9  9  10
4   25 8  8  23 23 23 9  9  10
5   25 24 24 24 23 23 11 11 10
6   20 20 21 21 22 23 11 12 12
7   20 19 21 21 22 16 16 12 13
8   19 19 19 18 22 16 15 14 13
9   19 19 18 18 17 17 15 14 13;
# region_sum[r] = sum of values in region r
param region_sum :=
 1  20
 2   8
 3  11
 4  12
 5  13
 6  10
 7  17
 8  13
 9  38
10  22
11  13
12  17
13   8
14  15
15  11
16  11
17  11
18  20
19  27
20  16
21  16
22  12
23  38
24  15
25  11;

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
