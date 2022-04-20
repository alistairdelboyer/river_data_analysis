function [horizontalPlume,horizontalTemp] =...
    getHorizontalPlumeData(xHorizontal,yHorizontal,horizontalPlumeData)
% [horizontalPlume,horizontalTemp =
% getHorizontalPlumeData(xHorizontal,yHorizontal,horizontalPlumeData) takes
% inputs of the cropped x and y range from the vertical plume, and the
% corresponding vertical plume thermal data, and returns the location of
% the centreline of the vertical plume, and the corresponding temperature
% of the vertical plume at the centreline

%searchRadius = 5;
Nx = numel(xHorizontal);
Ny = numel(yHorizontal);
horizY = zeros(size(xHorizontal));
horizontalTemp = zeros(size(xHorizontal));
for k = Nx:-1:1
%    if k == Nx
        [minVal,minInd] = min(horizontalPlumeData(:,k)); %find the minimum in a given column
%     else
%         %minLimit = max(1,minInd - searchRadius);
%         %maxLimit = min(Ny,minInd + searchRadius);
%         %s = sort([minLimit, maxLimit]);
%         %search = s(1):1:s(2);
%         data = horizontalPlumeData(max(1,minInd-1):1:min(Ny,minInd+1),k);
%         %         tempdata = data(data < 23); % CHANGE FROM HARD CODED THRESHOLD!
%         %         if isempty(tempdata)
%         %             tempdata = horizontalTemp(k+1);
%         %             ind = find(abs(data - tempdata) < 1e-1);
%         %         else
%         [minVal,ind] = min(data);
%         %ind = find(data == minVal);
%         if isempty(ind)
%             error('empty index')
%         end
%         minInd = minInd-1 + ind(1);
%     end
    indexStore(k) = minInd;
    horizY(k) = yHorizontal(indexStore(k)); % store the location of the minimum temperature
    horizontalTemp(k) = minVal; % store the minimum temperature
end
horizontalY = horizY;
horizontalPlume = [xHorizontal;horizontalY]; % concatenate

end
