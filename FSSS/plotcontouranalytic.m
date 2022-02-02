function plotcontouranalytic(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
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

% Create the figure
plotcontournumeric(z, x, y, dd, vecnum, scale)