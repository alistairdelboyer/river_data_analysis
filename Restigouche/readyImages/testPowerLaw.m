%% test analysis for restigouche %%
% clean slate and import
clc; clear; clf;
data = open('testData.mat');
hg = open('hydraulicGeometry.mat');
files = dir('*.png');
files = natsortfiles(files);
for l = 1:1:length(files)
    filename = files(l).name; %get file name
    %    filename = 'plumeFrom_img903.png';
    disp(['Processing: ' filename])
    %% import the image
    img = imread(filename);
    [o,t] = split(filename,'.');
    [oo,tt] = split(cellstr(o{1}),'_');
    imgName = oo{2};
    
    % import downstream data
    distance = data.downstreamDist.(imgName);
    T = data.downstreamTemp.(imgName);
    
    
    %plot(smooth(distance),smooth(T),'k.');
    % import hydraulic geometry values
    hyd = hg.hydraulicGeom.(imgName);
    Tamb = hyd.Tamb;
    lm = hyd.lm;
    
    % nondimensionalise with ambient temperature and momentum length of plume
    theta = 1 - T./Tamb;
    delta = distance/lm;
    
    % chop of the bit before the plume enters the channel
    [m,i] = max(theta);
    dstar = delta(i:end);
    Tstar = theta(i:end);
    Tstar(Tstar < 0) = NaN;
    
    % fit power law to chopped data
    xdata = smooth(dstar,0.1); ydata = smooth(Tstar,0.1); ydata(ydata < 0) = NaN;
    myFun = @(a,x) a(1)*x.^a(2); % define general power law
    nlm = fitnlm(xdata,ydata,myFun,[0.2 -1.1]);
    coefs = nlm.Coefficients.Estimate; % extract coefficients
    plot(xdata,ydata,'k.');
    hold on;
    plot(xdata,myFun(coefs,xdata),'r.')
    hold off
    disp(['R squared: ',num2str(nlm.Rsquared.Ordinary)])
    disp(['Power Law: ',num2str(coefs(1)),'x^',num2str(coefs(2))])
    pause()
end