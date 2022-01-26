function plotcontournumeric(z, x, y, dd, vecnum, scale)
% Plots the contours of the function g on the square whose corners are 
% (x_min,x_max) and (y_min,y_max)
%   Input:
%     z:        The 2D array containing z-values
%     x:        Either a vector or matrix of x-values
%     y:        Either a vector or matrix of y-values
%     dd:       The step/resolution of the graph
%     vecnum:   The approximate number of gradient vectors along an axis
%     scale:    The relative size of the gradient vectors
%   Output:
%     None

% Transform x and y into a meshgrid output if needed
[xx, yy] = getmeshgrid(x, y);

% Calculate the gradient numerically
[gxx,gyy] = gradient(z,dd);

% Create the contour plot
contour(xx,yy,z,10);
axx = gca;
axx.DataAspectRatio = [1,1,1];
colorbar;

% Find the first integer n such that min(size(xx))/n <= vecnum
% This is used to cut down on the number of vectors we plot for the
% gradient field, so that we have about vecnum vectors on the shorter axis
n = 1;
while min(size(xx))/n > vecnum
    n = n + 1;
end

% Superimpose the gradient field
hold on
quiver(xx,yy,split(gxx,n),split(gyy,n),scale)
hold off