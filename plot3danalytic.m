function plot3danalytic(g, x_min, x_max, y_min, y_max, dd, zar)
% Plots the function g on a cube whose base has corners (x_min,x_max)
% and (y_min,y_max)
%   Input:
%     g:        A 2D function to plot
%     x_min:    The lower bound on the x-axis of the graph
%     x_max:    The upper bound on the x-axis of the graph
%     y_min:    The lower bound on the y-axis of the graph
%     y_max:    The upper bound on the y-axis of the graph
%     dd:       The step/resolution of the graph
%   Output:
%     None

% Get the x and y coordinates we want the z values for
x = (x_min:dd:x_max);
y = (y_min:dd:y_max);
[xx, yy] = meshgrid(x, y);
z = evaluate2d(g, xx, yy);

% Create the figure
plot3dnumeric(z, xx, yy, x_min, x_max, y_min, y_max, zar)