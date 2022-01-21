% The main script used for plotting and calculating everything

% Properties:
% * What to plot:
%   ('plot2d', 'plot3d', 'plotcontour', 'fsssanalytic', or 'fsssnumeric')
plot_type = 'fsssnumeric';
% * General plot properties:
dd = 0.1;         % dd:     the step between min and max of x and y
x_min = -10;        % x_min:  lower bound on the x axis to graph
x_max = 10;       % x_max:  upper bound on the x axis to graph
y_min = -10;        % y_min:  lower bound on the y axis to graph
y_max = 10;       % y_max:  upper bound on the y axis to graph
% * plot3d properties:
zar = .05;         % zar:    z-axis aspect ratio
% * plotcontour properties:
scale = 8;        % scale:  adjusts the length of the gradient arrows
vecnum = 20;      % vecnum: approximate # of gradient vectors along an axis
% * fsss properties:
np = 1.333;       % The pattern-side index of refraction (1.333 for water)
n = 1;            % The camera-side index of refraction (1.000 for air)
hp = 2;           % The height of the liquid at rest
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
f = gaussian(x_offset_g, x_scale_g, y_offset_g, y_scale_g);
%f = @(x) y_scale_s*sin((x-x_offset_s)/(x_scale_s)) + y_offset_s;
%g = planewave1(f, 'y');
g = radialwave1(f);

% Run the specified plot_type
if isequal(plot_type,'plotcontour')
    plotcontour(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
elseif isequal(plot_type,'plot2d')
    plot2d(f, x_min, x_max, y_min, y_max)
elseif isequal(plot_type,'plot3d')
    plot3danalytic(g, x_min, x_max, y_min, y_max, dd, zar)
elseif isequal(plot_type,'fsssanalytic')
    % Calculate the displacement field from g
    dr = getdr(g, x_min, x_max, y_min, y_max, dd, np, n, hp, H);
    
    % Run the fsss equations
    h = fsss(dr, np, n, hp, H, dd);
    
    % Get the x and y coordinates
    x = (x_min:dd:x_max);
    y = (y_min:dd:y_max);
    
     % Make the plot
    plot3dnumeric(h, x, y, x_min, x_max, y_min, y_max, zar)
elseif isequal(plot_type,'fsssnumeric')
    % Import the data
    dr = loadvec("openpiv.txt");
    dr.fx = dr.vx;
    dr.fy = dr.vy;
    
    % Get the x and y coordinates
    x = dr.x;
    y = dr.y;
    
    % Run the fsss equations
    h = fsss(dr, np, n, hp, H, dd);
    
    % Make the plot
    plot3dnumeric(h, x ,y, min(x), max(x), min(y), max(y), zar)
end