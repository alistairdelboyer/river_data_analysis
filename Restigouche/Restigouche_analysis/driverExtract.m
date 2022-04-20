%%%%% does not work for img 0674 because changes vertical direction %%%%%%%

%% script to extract all the plumes for each png for Restigouche Region

%% clean slate %%
clc; clf; clear;%close all; clear;
%% include the path to files
%addpath matFiles/;
%filelist = dir('matFiles/*.MAT');
filelist = dir('*.MAT');
%% pick specific file to analyse
for l = length(filelist):-1:1
    clf; clc; % clear figure and comand window
    filename = filelist(l).name; %extract the filename
    disp(['Processing: ' filename])
    %% define parameters
    thermalMaskThreshold = 30; % temperature above which we don't care
    degThreshold = 0.01; % our accepted distance from ambient temperature
    smoothLevel = 0.01; % amount of smoothing for post processing
    pxVal = 0.485; %each pixel is 48.5cm^2

    % import image and convert to real world distances
    [img,imgName] = extractImage(filename,thermalMaskThreshold);
    [pY,pX] = size(img);
    % rescale x and y into real world values using known pixel distance
    xx = linspace(0,pxVal*pX,pX);
    yy = linspace(0,pxVal*pY,pY);
    imagesc(xx,yy,img); colormap(jet); colorbar; caxis([15 25])
    pause()
    %ambient = input('Input the ambient temperature of the river ');
    %% get horizontal plume
    disp('Please select the horizontal plume region')
    close;
    [horizontal,xHorizontal,yHorizontal] = getCropped(img);
    % round to whole numbers for image toolbox
    xHorizontal = round(pxVal*xHorizontal);
    yHorizontal = round(pxVal*yHorizontal);

    [horizontalPlume,horizontalTemp] =...
        getHorizontalPlumeData(xHorizontal,yHorizontal,horizontal);
    %% get vertical plume
    disp('Please select the vertical plume region')
    close;
    [vertical,xVertical,yVertical] = getCropped(img);
    xVertical = round(pxVal*xVertical);
    yVertical = round(pxVal*yVertical);

    [verticalPlume,verticalTemp] = getVerticalPlumeData(xVertical,...
        yVertical,vertical);
    %% knit together plume
    close;
    [xCoords, yCoords, ~] = knitData(horizontalPlume,...
        verticalPlume,horizontalTemp, verticalTemp);

    %% plot the plume onto the thermal image
    figure(1)
    clf;
    imagesc(xx,yy,img); colormap(jet); colorbar(); hold on;
    xCoords = smooth(xCoords,smoothLevel);
    yCoords = smooth(yCoords,smoothLevel);
    plot(xCoords,yCoords,'w-.','linewidth',2)
    pause()
    hold off;

    % plot the temperature vs the length of the plume
    figure(2)
    clf;
    dist = zeros(size(xCoords)); % initialise the cumulative distance
    for k = 2:numel(xCoords)
        % compute distance between consecutive points
        d = sqrt((xCoords(k) - xCoords(k-1)).^2 + (yCoords(k) - yCoords(k-1)).^2);
        dist(k) = dist(k-1) + d; % get the cumulative distance
    end
    downstreamDist.(imgName) = dist;
    temp = interp2(xx,yy,img,xCoords,yCoords); % get temperature at plume coords
    downstreamTemp.(imgName) = temp;
     plot(dist,temp,'bsq');
     pause()
% %     hold on;
% %     % plot a line for half a degC less than ambient temp
% %     yl1 = yline(ambient - degThreshold);
% %     yl1.LineWidth = 2;
% %     yl1.Color = 'r';
% %     yl1.LineStyle = '--';
% %     % plot a line for the ambient temperature
% %     yl2 = yline(ambient);
% %     yl2.LineWidth = 2;
% %     yl2.Color = 'r';
% %     xlabel('Distance along the plume centreline, m','fontsize',26,'interpreter','latex')
% %     ylabel('Temperature, degC','fontsize',26,'interpreter','latex')
% %     pax = gca;
% %     pax.TickLabelInterpreter = 'latex';
% %     pax.FontSize = 24;
% %     legend('Temperature at plume centreline','Ambient temperature - 1/2 degC','Ambient temperature','fontsize',24,'interpreter','latex')
% %     axis square
end
