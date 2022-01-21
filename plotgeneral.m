% The main script used for plotting and calculating everything

% Properties:
% * What to plot ('plot2d', 'plot3d', 'plotcontour', or 'fsss')
plot_type = 'fsss';
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
% * fsss properties:
np = 1.333;       % The pattern-side index of refraction (1.333 for water)
n = 1;            % The camera-side index of refraction (1.000 for air)
hp = 3;           % The height of the liquid at rest
H = 1000;         % The camera-pattern distance

% Function properties and definitions (f(x) is 1D, g(x,y) is 2D):
% * Gaussian function parameters used in @gaussian
x_offset_g = 5.4;
x_scale_g = 1.7;
y_offset_g = 2;
y_scale_g = 5;

% * Sin function parameters used in sin
x_offset_s = 0;
x_scale_s = 1.2;
y_offset_s = 2;
y_scale_s = 1/2;


% * Define the functions used
%f = gaussian(x_offset, x_scale, y_offset, y_scale)
f = @(x) y_scale_s*sin((x-x_offset_s)/(x_scale_s)) + y_offset_s;
g = planewave1(f, 'y');
%g = radialwave1(f);

% Run the specified plot_type
if isequal(plot_type,'plotcontour')
    plotcontour(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
elseif isequal(plot_type,'plot2d')
    plot2d(f, x_min, x_max, y_min, y_max)
elseif isequal(plot_type,'plot3d')
    plot3danalytic(g, x_min, x_max, y_min, y_max, dd, zar)
elseif isequal(plot_type,'fsss')
    % Calculate the displacement field from g
    dr = getdr(g, x_min, x_max, y_min, y_max, dd, np, n, hp, H);
    h = fsss(dr, np, n, hp, H, dd);
    plot3dnumeric(h, x_min, x_max, y_min, y_max, dd, zar)
end