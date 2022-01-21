% The main script used for plotting and calculating everything

% Properties:
% * What to plot ('plot2d', 'plot3d', or 'plotcontour')
plot_type = 'plot3d';
% * General plot properties:
dd = 0.1;         % dd:     the step between min and max of x and y
x_min = 0;        % x_min:  lower bound on the x axis to graph
x_max = 60;       % x_max:  upper bound on the x axis to graph
y_min = 0;        % y_min:  lower bound on the y axis to graph
y_max = 40;       % y_max:  upper bound on the y axis to graph
% * plot3d properties:
zar = .1;         % zar:    z-axis aspect ratio
% * plotcontour properties:
scale = 8;        % scale:  adjusts the length of the gradient arrows
vecnum = 20;      % vecnum: approximate # of gradient vectors along an axis

% Function properties and definitions (f(x) is 1D, g(x,y) is 2D):
% * Gaussian function parameters used in @gaussian
x_offset = 5.4;
x_scale = 1.7;
y_offset = 2;
y_scale = 5;

% * Define the functions used
%f = gaussian(x_offset, x_scale, y_offset, y_scale)
f = @(x) (1/2)*sin(x/(1.2)) + 2;
g = planewave1(f, 'y');
%g = radialwave1(f);

% Run the specified plot_type
if isequal(plot_type,'plotcontour')
    plotcontour(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
elseif isequal(plot_type,'plot2d')
    plot2d(f, x_min, x_max, y_min, y_max)
elseif isequal(plot_type,'plot3d')
    plot3d(g, x_min, x_max, y_min, y_max, dd, zar)
end