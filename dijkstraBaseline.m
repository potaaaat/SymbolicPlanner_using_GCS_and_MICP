function [path, dist] = dijkstraBaseline(config)
    %freforms Dijkstra's algorithm on a graph. Dijkstra requires no negative
    %edges, which is no problems for this projects graphs.
    %for every operation that can be executed from the current state, 
    % check whether using that operation gives a shorter plan to the resulting state.

    n = config.numNodes;

    dist = inf(1,n);
    prev = nan(1,n);
    visited = false(1,n);

    dist(config.source) = 0;
    
    tic;
    while true
        %find unvisited nodes 
        candidates = find(~visited);

        if isempty(candidates)
            break;
        end

        [~,idx] = min(dist(candidates));
        u = candidates(idx);
    
        if isinf(dist(u))
            break;
        end
    
        if u == config.goal
            break;
        end
    
        visited(u) = true;
        for e = 1:length(config.edges)

            if config.edges(e).from ~= u
                continue;
            end
    
            v = config.edges(e).to;
    
            alt = dist(u) + 1;   % unit operation cost
    
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end
    solveTime = toc;
    fprintf('solve time: %.4f', solveTime);

    dist = dist(config.goal);

    %The path
    path = config.goal;
    
    while path(1) ~= config.source
        path = [prev(path(1)), path];
    
        if isnan(path(1))
            error('No feasible path found.');
        end
    end

end

