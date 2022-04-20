% script to evaluate the temperature change downstream of the confluence
% plume

%% clean slate
clc; clear; clf;
addpath /home/pmxad8/Documents/Postdoc/Fieldwork/Fieldwork_Restigouche_Plume/combinedPlumeImages
% extract all png files in the current directory
files = dir('*.png');
files = natsortfiles(files); %sort to ascending order for convenience

for l = 1:1:length(files)
    filename = files(l).name; %get file name
%    filename = 'plumeFrom_img903.png';
    disp(['Processing: ' filename])
    %% import the image
    img = imread(filename);
    [o,t] = split(filename,'.');
    [oo,tt] = split(cellstr(o{1}),'_');
    imgName = oo{2};
    img = double(img);
    img = img(:,:,1)./100;
    img = img - 273.15;
    img(img <= 10) = NaN;
    
    if filename == 'plumeFrom_img970.png'
        img = imrotate(img,-90);
    end
    preImg = img;
    smoothSize = 10;
    smoother = 1/smoothSize^2 * ones(smoothSize);
    img = conv2(img,smoother,'same');
    %% visualise the image in true scale
    [py,px] = size(img);
    pxVal = 0.485; % pixel to m conversion -> each pixel is 0.485m
    xx = linspace(0,pxVal*px,px); %convert x and y to metres
    yy = linspace(0,pxVal*py,py);
    imagesc(xx,yy,img) %visualise in real world distances
    colorbar;
    colormap(jet)
    %colormap(parula)
    caxis([15 35])
    axis([0 xx(end) 0 yy(end)])
    axis equal
    %% extract the horizontal plume region
    disp('Please select the horizontal plume region')
    close;
    [horizontal,xHorizontal,yHorizontal] = getCropped(img);
    xHorizontal = round(pxVal*xHorizontal);
    yHorizontal = round(pxVal*yHorizontal);
    
    [horizontalPlume,horizontalTemp] =...
        getHorizontalPlumeData(xHorizontal,yHorizontal,horizontal);
    imagesc(xx,yy,img); hold on;
    plot(horizontalPlume(1,:), horizontalPlume(2,:),'w.');
    colormap(parula);
    %srthfdgh
    %% get vertical plume
    % NOTE: you must select points that capture the top, bottom, left and right
    % of the plume!
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
    imagesc(xx,yy,img); colormap(parula); caxis([15 30]); colorbar(); hold on;
    %xCoords = smooth(xCoords); yCoords = smooth(yCoords) ;
    plot(xCoords,yCoords,'r.','linewidth',2)
    axis equal
    axis([0 xx(end) 0 yy(end)])
    hold off;
    %pause()
    figure(2)
    clf;
    dist = zeros(size(xCoords)); % initialise the cumulative distance
    for k = 2:numel(xCoords)
        % compute distance between consecutive points
        d = sqrt((xCoords(k) - xCoords(k-1)).^2 + (yCoords(k) - yCoords(k-1)).^2);
        dist(k) = dist(k-1) + d; % get the cumulative distance
    end
    %%
    dist = smooth(dist,0.025);
    downstreamDist.(imgName) = dist;
    temp = interp2(xx,yy,img,xCoords,yCoords);
    downstreamTemp.(imgName) = temp;
    plot(dist,temp,'b.'); %remove any noise with nearest neighbour filter
    pause()

%figure(1)
%imagesc(xx,yy,img); hold on; plot(xCoords,yCoords,'r.');
end