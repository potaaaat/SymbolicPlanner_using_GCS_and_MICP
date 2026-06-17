clear; clc;

doorExample = false; %toggle for dooexaple as the code slightly differs for it (prinitng results etc)
config = config_reducedManufacturing(); %config_doorExample();

numEdges = length(config.edges);
numNodes = config.numNodes;

incidenceMatrix = zeros(numNodes, numEdges);

for edge = 1:numEdges
    F = config.edges(edge).F;
    g = config.edges(edge).g;
    %we can wrie our flow problem as incidenceMatrix * phi = b_flow
    incidenceMatrix(config.edges(edge).from, edge) = 1;
    incidenceMatrix(config.edges(edge).to, edge) = -1;

end

b_flow = zeros(numNodes,1);
b_flow(config.source) = 1;
b_flow(config.goal) = -1;

M = 2; 

if config.source == config.goal

    fprintf('Source already equals goal.\n');
    fprintf('Path: %d\n', config.source);

    return

end


tic     
cvx_begin 
    variable phi(numEdges) binary
    variables X(config.n, numNodes)

    minimize(sum(phi))
    subject to
        incidenceMatrix*phi == b_flow;
        for node = 1:numNodes
            if strcmp(config.constraintType, 'polytope')
               
                    config.A*X(:,node) <= config.node(node).b;
               
            elseif strcmp(config.constraintType,'sharedSimplex')
                for s = 1:length(config.stateVar)
    
                    idx = config.stateVar(s).idx; 
                    switch config.stateVar(s).type
        
                        case 'simplex'
        
                            X(idx,node) >= 0;
                            X(idx,node) <= 1;
                            sum(X(idx,node)) == 1;
        
                        case 'interval'
        
                            X(idx,node) >= config.stateVar(s).lb;
                            X(idx,node) <= config.stateVar(s).ub;
        
                    end
    
                end
            end

        end

        for edge = 1:numEdges
            z = [X(:,config.edges(edge).from);
                 X(:,config.edges(edge).to)];
            
            config.edges(edge).F * z <= M* (1-phi(edge))+ config.edges(edge).g;
        end

cvx_end
solveTime = toc;
optval = cvx_optval;

disp(optval)


disp('initial state: ');
fprintf('\nInitial state:\n');
disp(config.node(config.source).state);
fprintf('Goal state:\n');
disp(config.node(config.goal).state);

%find active edges
tolerance = 1e-6;
activeEdges = find(phi > tolerance);

path = config.source;
current = config.source;

if doorExample %prining for door example slightly different for doorexample as it is slightly simpler
    nextNode = containers.Map('KeyType','double','ValueType','double');

    for k = 1:length(activeEdges)
        edge = activeEdges(k);
    
        nextNode(config.edges(edge).from) = config.edges(edge).to;
    end

    while current ~= config.goal
        current = nextNode(current);
        path(end+1) = current;
    end
    
    fprintf('Active transitions:\n');
    for k = 1:length(path)
    
        if k < length(path)
            fprintf('%d -> ', path(k));
        else
            fprintf('%d\n', path(k));
        end
    end
    
else
    nextNode = containers.Map('KeyType','double','ValueType','double');
    nextEdge = containers.Map('KeyType','double','ValueType','double');
    
    for k = 1:length(activeEdges)
        edge = activeEdges(k);
    
        from = config.edges(edge).from;
        to   = config.edges(edge).to;
    
        nextNode(from) = to;
        nextEdge(from) = edge;
    end
    operationPath = strings(0);

    while current ~= config.goal
        e = nextEdge(current);
    
        operationPath(end+1) = config.edges(e).operation;
    
        current = nextNode(current);
        path(end+1) = current;
    end

    % print operations
    fprintf('Operation plan:\n');
    
    % for k = 1:length(operationPath)
    %     fprintf('%d. %s\n', k, operationPath(k));
    % end

    for k = 1:length(operationPath)
        fromNode = path(k);
        toNode   = path(k+1);
        fprintf('%d. %s: [%d %d %d] -> [%d %d %d]\n', k, operationPath(k), config.node(fromNode).state, config.node(toNode).state);
    end
    
    %print node path
    fprintf('Node path:\n');
    for k = 1:length(path)
        if k < length(path)
            fprintf('%d --> ', path(k));

        else
            fprintf('%d\n', path(k));
        end
    end
end


%fprintf('\nFlow variables:\n');
%disp(phi')
fprintf('Solve time: %.4f seconds\n', solveTime);
