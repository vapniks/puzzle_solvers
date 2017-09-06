# puzzle_solvers
Various mathematical optimization programs written in ampl for solving puzzles.

A Mathematical Programming Language ([AMPL](http://ampl.com)) is an algebraic modeling language for describing 
high-complexity problems for large-scale mathematical computing (i.e., large-scale optimization and scheduling-type problems).  
This is a commercial product but a free demo version is available which can easily handle the problems in this repo.  
AMPL works in conjunction with various optimization solvers such as [cplex](https://www-01.ibm.com/software/commerce/optimization/cplex-optimizer/) and [gurobi](http://www.gurobi.com/), and translates the problem code into a format which can be understood by these solvers.  
For the puzzles in this repo the [gecode](http://www.gecode.org/) solver was used since this provides constraint programming facilities which makes it much easier to write the program in ampl code. Gecode is free software and can be downloaded from here: http://www.gecode.org/download.html

The model files (.mod) contain fixed data which can be altered to fit the particular puzzle instance you are trying to solve.

Assuming you have installed a copy of ampl and gecode you can solve files from the linux command line like so:  
> ampl <PATH_TO_FILE>  
or just make the files executable and they should just run by themselves via the hashbang.
