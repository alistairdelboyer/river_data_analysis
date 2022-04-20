clc; clear;
addpath matFiles/; % add path to the mat files

filelist = dir('matFiles/*.MAT'); % extract the names of each mat file

% for each mat file, extract the name and the part of name before extension
for k = 1:length(filelist)
    baseFileName = filelist(k).name; % get full name
    firstFile = split(baseFileName,'.'); % split name at .
    imgName = firstFile{1}; % get bit before the extension

    data = open(baseFileName); % read in the mat file
    img = data.(imgName) - 273; % convert from K to deg C
    img(img > 25) = 25; % mask at 25 deg C
    
    % visualise
    imagesc(img);
    colormap(jet);
    colorbar;
    
    disp(['Now showing: ', baseFileName])
    pause(1)
end