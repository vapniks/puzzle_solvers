# ----------------------------------------
# AMPL MODEL TO SOLVE KILLER SUDOKO 
# ----------------------------------------

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
param numregions := 29;
# region[i,j] = region number for i,j entry of grid
param region:
    1  2  3  4  5  6  7  8  9 :=
1   1  1  2  2  2  3  4  5  6 
2   7  7  8  8  3  3  4  5  6 
3   7  7  9  9  3 10 11 11  6 
4  13 14 14  9 15 10 11 12  6 
5  13 16 16 17 15 10 12 12 18 
6  19 16 20 17 15 21 22 22 18 
7  19 20 20 17 23 21 21 24 24 
8  19 25 26 23 23 27 27 24 24 
9  19 25 26 23 28 28 28 29 29 ;
# region_sum[r] = sum of values in region r
param region_sum :=
 1   3
 2  15
 3  22
 4   4
 5  16
 6  15
 7  25
 8  17
 9   9
10   8
11  20
12  17
13   6
14  14
15  17
16  13
17  20
18  12
19  27
20   6
21  20
22   6
23  10
24  14
25   8
26  16
27  15
28  13
29  17;

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
