function plot2d(f, x_min, x_max, y_min, y_max)
% Plots the function f on the square whose corners are (x_min,x_max)
% and (y_min,y_max)
%   Input:
%     f:        A 1D function to plot
%     x_min:    The lower bound on the x-axis of the graph
%     x_max:    The upper bound on the x-axis of the graph
%     y_min:    The lower bound on the y-axis of the graph
%     y_max:    The upper bound on the y-axis of the graph
%   Output:
%     None

% Get the x and y values we'll be plotting
x = linspace(x_min,x_max,100);
y = f(x);

% Create the plot
p = plot(x,y);

% Modify the plot's properties
ax = p.Parent;
ax.XLim = [x_min, x_max];
ax.YLim = [y_min, y_max];

xlabel('x')
ylabel('y')