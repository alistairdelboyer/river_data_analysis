function [verticalPlume,verticalTemp] = getVerticalPlumeData(xVertical,...
    yVertical,verticalPlumeData)
% [verticalPlume,verticalTemp =
% getVerticalPlumeData(xVertical,yVertical,verticalPlumeData) takes inputs of
% the cropped x and y range from the vertical plume, and the corresponding
% vertical plume thermal data, and returns the location of the centreline
% of the vertical plume, and the corresponding temperature of the vertical
% plume at the centreline
searchRadius = 5;
vertX = zeros(size(yVertical));
verticalTemp = zeros(size(yVertical));

Nx = numel(xVertical);
Ny = numel(yVertical);

for k = 1:Ny
    if k == 1
        [minVal,minInd] = min(verticalPlumeData(k,:)); % find min of a row
    else
        minLim = max(1,minInd - searchRadius);
        maxLim = min(Ny,minInd + searchRadius);
        s = sort([minLim,maxLim]);
        search = s(1):1:s(2);
        [minVal,mi] = min(verticalPlumeData(k,search));
        minInd = s(1) - 1 + mi;
    end
    vertX(k) = xVertical(minInd); %store min location
    verticalTemp(k) = minVal; % store min temperature
end
verticalX = smooth(vertX,0.025)'; %smooth with nearest neighbour filter and transpose to concatenate
verticalPlume = [verticalX;yVertical]; % concatenate
