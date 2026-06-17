function config = config_reducedManufacturing()
    config.constraintType = "sharedSimplex"; %unlike for door example all 
    % nodes share the same simplex embedding
    
    config.stateVar(1).name = 'AGV1_pos';
    config.stateVar(1).idx = 1:4;
    config.stateVar(1).type ='simplex';
    
    config.stateVar(2).name = 'R1_pos';
    config.stateVar(2).idx = 5:7;
    config.stateVar(2).type ='simplex';
    
    config.stateVar(3).name = 'Item_pos';
    config.stateVar(3).idx = 8:10;
    config.stateVar(3).type ='simplex';
    
    config.n = 10;%dimension of statevector
    
    %state:
    AGV1_pos = eye(4);
    R1_pos = eye(3);
    item_pos = eye(3);
      
    %generate all combinations:
    node = 0;
    
    for agv1 = 0:3
        for r1 = 1:3
            for item = 1:3
                node = node + 1;
                config.node(node).state = [agv1, r1, item];
        
            end
        end
    end
    config.numNodes = node; %this case 36

    %edges:
    edge = 0;

    for i = 1:config.numNodes
        for j = 1:config.numNodes
            if i == j
                continue;
            end
            operation = identifyOperation_reducedManufacturing(config.node(i).state, config.node(j).state);

            if operation ~= ""
                edge = edge +1;
                config.edges(edge).from = i;
                config.edges(edge).to = j;
                config.edges(edge).operation = operation;
                
                % Big-M constraint needs F and g, so give empty matrices.
                config.edges(edge).F = zeros(0, 2*config.n);
                config.edges(edge).g = zeros(0, 1);

            end
        end 
    end
    
    
    %inital and goal States
    initialState = [0,2, 1]; %agv at pos 0, r1 at buffer and item at conveyorbelt
    goalState = [3, 2, 3]; %(agv1 at pos 3, item on the agv and r1 waiting in buffer)
    %find node number of initial state
    config.source = NaN;
    config.goal = NaN;

    for i = 1:config.numNodes
        if isequal(config.node(i).state, initialState)
            config.source = i;
        end
        if isequal(config.node(i).state, goalState)
            config.goal = i;
        end
    end

    if isnan(config.source) 
        error('Initial state not found in the configuration nodes. Please try again');
    elseif isnan(config.goal) 
        error('Goal state not found in the configuration nodes. Please try again');
    end
        
  
   
end