function config = config_doorExample()
%%%----This file contains all the matrixes (varables) for the door example------%%%
%%% Load this in the symbolic planner file!

config.constraintType = 'polytope'; %for the doorexample we can manually 
% define all states allowing each node to have its own small convex set.
% This differs from the reduced manufacturing example where all nodes instead
% share the same simplex embedding

config.n = 2; %dimension of state vector

%Convex sets for nodes
config.A = [1 0; -1 0; 0 1; 0 -1];
epsilon = 0.05; % Small tolerance used to define narrow convex regions

config.numNodes = 3;

topPart = blkdiag(config.A, config.A); %the forst rows of every Chi have identical forst rows since all Aij = A for all i,j
E_open = [1 0 -1 0; -1 0 1 0];
E_locked = [ 0 -1 0 1; 0 1 0 -1];

config.node(1).b = [epsilon; 0; 1; epsilon-1];
config.node(2).b = [epsilon; 0; epsilon; 0];
config.node(3).b = [1; -(1-epsilon); epsilon; 0];

%edge 1 to 2:
config.edges(1).from = 1;
config.edges(1).to = 2;
config.edges(1).F = [topPart; E_open];
config.edges(1).g = [config.node(1).b;config.node(2).b;0;0];

%edge 2 to 1:
config.edges(2).from = 2;
config.edges(2).to = 1;
config.edges(2).F = [topPart; E_open];
config.edges(2).g = [config.node(2).b;config.node(1).b;0;0];


%edge 2 to 3
config.edges(3).from = 2;
config.edges(3).to = 3;
config.edges(3).F = [topPart; E_locked];
config.edges(3).g = [config.node(2).b;config.node(3).b;0;0];

%edge 3 to 2
config.edges(4).from = 3;
config.edges(4).to = 2;
config.edges(4).F = [topPart; E_locked];
config.edges(4).g = [config.node(3).b;config.node(2).b;0;0];


config.source = 3;
config.goal = 2;

end