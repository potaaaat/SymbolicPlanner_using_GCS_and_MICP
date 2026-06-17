# SymbolicPlanner_using_GCS_and_MICP
SYMBOLIC PLANNER using GCS and MICP:

Overview:
This project implements a symbolic planning framework using convex relaxations and mixed-integer optimization. The planner supports different state embeddings and solves planning problems using CVX with the MOSEK solver.

STRUCTURE OF THE IMPLEMENTATION:

Currently 3 different embedding types suported:
* Polytope:
	- used for the door example.
	- Used for boolean variables; boolean variables are
		embedded as convex polyhedral neigbourhoods Ax<=b

* Simplex:
	- Used for symbolic/categorical variables
	- Onehot encodings that are relaxed into their convex hull

*Interval:
	- Used for physical integer quantities.
	- Integer domains are directly relaxed into intervals: x 
		\in [l, u]
	- This was never iplemented for any of the state variables due to scope limitations (AGV1_pos was treated like Simplex instead)


SOLVER:
Implementation uses CVX and MOSEK. 
REQUIREMENTS: 
* MATLAB
* CVX
* MOSEK

FILES:

symbolicPlanner.m
Main planner implementation. Needs a configuration file to run (each example has it's own configuration file).

config_doorExample.m
Configuration for the door planning example.

config_reducedManufacturing.m
Configuration for the reduced manufacturing example.

identifyOperation_reducedManufacturing.m
Generates valid operations/transitions for the manufacturing example.

dijkstraBaseline.m
Dijkstra shortest-path baseline implementation.

runDijkstra.m
Script for running the Dijkstra baseline.



HOW TO RUN THE PLANNER:
1. Open symbolicPlanner.m.

2. Select the desired configuration:

	Door example:
	config = config_doorExample();

	OR

	Manufacturing example:
	config = config_reducedManufacturing();

3. For the door example set:
	doorExample = true;
	
	OR

	For the manufacturing example set:
	doorExample = false;
4. Run:
	symbolicPlanner.m

The script will output:

Optimal objective value
Operation sequence
Node path
Solver runtime

If you want to change the Initial or Goal state, you can manualy do it in the configuration files.

For DoorExample:
1. Open config_doorExample.m
2. Find:
	config.source = 3;
	config.goal = 2;

	The numbers correspond to the state number
3. Change the number to your desiered states

For Manufacturing example:
1. Open config_reducedManufacturing.m
2. Find:

    initialState = [0,2, 1]; 
    goalState = [3, 2, 3]; 

	the numbers in the Array corresponds to the different state variables. The first one is the AGV1_pos this one can be either 0,1,2, or 3. The next on is the R1_pos which can be 1,2, or 3. The last one is Item_pos  which also can be 1,2, or 3. They directly correspond to Table 1 in the Report.

3. change the arrays to the states you want.


HOW TO RUN THE DIJKSTRA BASELINE

1. Open runDijkstra.m.
2. Select the desired configuration:
	config = config_doorExample();
	or
	config = config_reducedManufacturing();
3.Run:
	runDijkstra.m

The script will output:

Shortest path
Path length
Runtime

NOTES

The manufacturing example contains 36 symbolic states.
The planner minimizes the number of active transitions.
If source and goal states are identical, the planner terminates immediately.
