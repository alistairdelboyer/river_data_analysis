function [img,imgName] = extractImage(filename,threshold)
% img = extractImage(filename,threshold) takes an imput of a file name 
% corresponding to a .MAT file and a threshold temperature in deg C. 

% temperature data > threshold is set to threshold for clearer
% visualisation

% if threshold not defined, set it to the max
first = split(filename,'.'); % split filename at .
imgName = first{1}; % extract only the part of name before the .

% if MAT file, just pull out the temperature
if first{2} == 'MAT'
    data = open(filename);
    img = data.(imgName) - 273; % extract temperature data and convert to deg C
elseif first{2} == 'png' %if png, read the entire image as temperature stored implicitly and is in degC
    img = imread(filename);
end
% if no thershold added, threshold at the maximum
if ~exist('threshold','var')
    threshold = max(img(:));
end
img(img > threshold) = threshold; % mask at threshold;

end
