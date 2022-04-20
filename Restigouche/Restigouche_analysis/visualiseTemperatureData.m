clc; clear; clf;
addpath ~/Downloads/;
%addpath ~/Documents/Postdoc/Fieldwork_Restigouche/knitTest/combinedPlumeImages
%data = open('downstreamDataRestigoucheProcessed.mat');
data = open('downstreamValues.mat');
hg = open('hydraulicGeometry.mat');
hg = hg.hydraulicGeom;
%temp = data.trimmedTemp;
temp = data.downstreamTemp;
%dist = data.trimmedDist;
dist = data.downstreamDist;
smoothThreshold = 0.10;
fieldnames = fieldnames(dist);
fieldnames = natsortfiles(fieldnames);
% hold on;
Legend = cell(length(fieldnames),1);
c = distinguishable_colors(length(fieldnames));
fig = figure(1);
set(fig,'Position',[0 0 1000 1000])
for k = 1:length(fieldnames)
    name = fieldnames(k);
    name = char(name);
    dmp = dist.(name);
    d = smooth(dmp,smoothThreshold);
    tmp = temp.(name);
    %tmp(tmp > 25) = NaN;
    T = smooth(tmp,smoothThreshold);
    %plot(d,t,'color',c(k,:),'linestyle','-','linewidth',2)
    splitName = split(name,'_');
    legName = splitName{2};
    lm = hg.(legName).rplume;
    Tamb = hg.(legName).Tamb;
    %ds = d/lm;
    %theta = 1 - t/Tamb;
    plot(d,(Tamb-T)./Tamb,'color',c(k,:),'linestyle','-','linewidth',2)
    %legName = name;
    %title(legName)
    Legend{k} = legName;
    %ylim([15 30])
    hold on
    pause()
end
legend(Legend,'fontsize',20,'interpreter','latex','location','southeast')
xlabel('Downstream Distance,m','fontsize',24,'interpreter','latex')
ylabel('Temperature, degC','fontsize',24,'interpreter','latex')
pax = gca;
pax.FontSize = 24;
pax.TickLabelInterpreter = 'latex';
axis square