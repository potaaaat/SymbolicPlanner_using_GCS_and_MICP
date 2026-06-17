function operation = identifyOperation_reducedManufacturing(x,y)
    %we need a way to check if our operations are valid
    %NOTE! this is hardcoded for the reduced manufacturing environment
    %basically what is described here is the possible operations if the environment
    agv1_1  = x(1); r1_1  = x(2); item_1  = x(3);
    agv1_2 = y(1); r1_2 = y(2); item_2 = y(3);

    operation = "";

    %check agv movement:
    if r1_1 == r1_2 && item_1 == item_2

        allowedAGVMoves = [0 1; 1 0; 0 2; 2 0; 2 3; 3 2]; %the allowed movements of the agv 

        if ismember([agv1_1 agv1_2], allowedAGVMoves, 'rows')
            operation = sprintf("Move AGV1 %d to %d", agv1_1, agv1_2);
            return
        end
    end

    %check R1 movement
    if agv1_2 == agv1_1 && item_2 == item_1
        allowedR1Moves = [1 2; 2 1; 2 3; 3 2];

        if ismember([r1_1 r1_2], allowedR1Moves, 'rows')
            operation = sprintf("Move R1 %d to %d", r1_1, r1_2);
            return
        end
    end

    %pickup item
    if agv1_1 == agv1_2 && r1_2 == r1_1
        if r1_1 == 1 && item_1 == 1 && item_2 == 2 
            operation = "PickUpItem";
            return;
        end
    end

    %dropitem
    if agv1_2 == agv1_1 && r1_1 == r1_2
        if item_1 == 2 && item_2 == 3 && r1_1 == 3 && agv1_1 == 0
            operation = "DropItem";
            return;
        end
    end
end