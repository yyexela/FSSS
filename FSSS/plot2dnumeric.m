function plot2dnumeric(x, y, x_min, x_max, y_min, y_max)
% Plots the points on a square whose base whose corners are (x_min,x_max)
% and (y_min,y_max)
%   Input:
%     x:        A vector of x-values
%     y:        A vector of y-values
%     x_min:    The lower bound on the x-axis of the graph
%     x_max:    The upper bound on the x-axis of the graph
%     y_min:    The lower bound on the y-axis of the graph
%     y_max:    The upper bound on the y-axis of the graph
%   Output:
%     None

% Create the plot
p = plot(x,y);

% Modify the plot's properties
ax = p.Parent;
ax.XLim = [x_min, x_max];
ax.YLim = [y_min, y_max];

xlabel('x (mm)')
ylabel('y (mm)')
ax.FontSize = 12;
