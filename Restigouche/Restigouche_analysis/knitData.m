function [xCoords, yCoords,temperature] = knitData(horizontalPlume,...
    verticalPlume,horizontalTemp,verticalTemp)
% [xCoords, yCoords,temperature] = knitData(horizontalPlume,...
% verticalPlume,horizontalTemp,verticalTemp) takes inputs from the
% horizontal and vertical plume components to smoothly knit the data
% together depending on the direction of the river flow

%verticalPlume(1,:) = smooth(verticalPlume(1,:),0.2);
%verticalPlume(2,:) = smooth(verticalPlume(2,:),0.2);
isL2R = input('Is the plume flowing left to right [Y/N]? ','s'); % is plume flowing left to right?
isT2B = input('Is the plume flowing top to bottom [Y/N]? ','s'); % is plume flowing top to bottom?
if isL2R == 'Y'
    if isT2B == 'Y'
        % if left to right and top to bottom, data in correct order
        xCoords = [horizontalPlume(1,:) verticalPlume(1,:)];
        yCoords = [horizontalPlume(2,:) verticalPlume(2,:)];
        temperature = [horizontalTemp verticalTemp];
    else
        % if left to right and bottom to top, flip order from vertical
        % component
        xCoords = [horizontalPlume(1,:) fliplr(verticalPlume(1,:))];
        yCoords = [horizontalPlume(2,:) fliplr(verticalPlume(2,:))];
        temperature = [horizontalTemp fliplr(verticalTemp)];
    end
elseif isL2R == 'N'
    if isT2B == 'Y'
        % if right to left and top to bottom, flip horizontal order
        xCoords = [fliplr(horizontalPlume(1,:)) verticalPlume(1,:)];
        yCoords = [fliplr(horizontalPlume(2,:)) verticalPlume(2,:)];
        temperature = [fliplr(horizontalTemp) verticalTemp];
    else
        % if right to left and bottom to top, flip both directions
        xCoords = [fliplr(horizontalPlume(1,:)) fliplr(verticalPlume(1,:))];
        yCoords = [fliplr(horizontalPlume(2,:)) fliplr(verticalPlume(2,:))];
        temperature = [fliplr(horizontalTemp) fliplr(verticalTemp)];
    end

end
