function [croppedImg,x,y] = getCropped(img)
% function croppedImg = getCropped(img) takes an image input and allowed
% the user to extra an area. Extract the area containing the plume
fig = figure(1);
set(fig,'Position',[0 0 1000 1000])
imagesc(img); colormap(jet);
noInputs = 4;
disp(['Please select ', num2str(noInputs),' points around the confluence plume'])
[X,Y] = ginput(4); % user must select 4 points around the plume
X = round(X); Y = round(Y); % round to whole numbers for image visualisation
% crop the image in the range of Y and range of X from the 4 points chosen
x = min(X):max(X);
y = min(Y):max(Y);
croppedImg = img(y,x); 

end
