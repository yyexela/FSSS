function plotcontour(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
% Plots the contours of the function g on the square whose corners are 
% (x_min,x_max) and (y_min,y_max)
%   Input:
%     g:        A 2D function to plot
%     x_min:    The lower bound on the x-axis of the graph
%     x_max:    The upper bound on the x-axis of the graph
%     y_min:    The lower bound on the y-axis of the graph
%     y_max:    The upper bound on the y-axis of the graph
%     dd:       The step/resolution of the graph
%     vecnum:   The approximate number of gradient vectors along an axis
%     scale:    The relative size of the gradient vectors
%   Output:
%     None

% Get the x and y coordinates we want the z values for
x = (x_min:dd:x_max);
y = (y_min:dd:y_max);
[xx, yy] = meshgrid(x, y);
z = evaluate2d(g, xx, yy);

% Calculate the gradient numerically
[gxx,gyy] = gradient(z,dd);

% Create the contour plot
p = contour(xx,yy,z);
axx = gca;
axx.DataAspectRatio = [1,1,1];

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