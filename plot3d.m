% Various parameters used in this script
dd = 0.1;   % dd:     the step between min and max of x and y
x_min = 0;  % x_min:  lower bound on the x axis to graph
x_max = 60; % x_max:  upper bound on the x axis to graph
y_min = 0;  % y_min:  lower bound on the y axis to graph
y_max = 40; % y_max:  upper bound on the y axis to graph
zar = .1;    % zar:    z-axis aspect ratio

% Gaussian function parameters used in @gaussian
x_offset = 5.4;
x_scale = 1.7;
y_offset = 2;
y_scale = 5;

% Obtain the function g we'll be plotting
%f = gaussian(x_offset, x_scale, y_offset, y_scale
f = @(x) (1/2)*sin(x/(1.2)) + 2;
g = planewave1(f, 'y');

% Get the x and y coordinates we want the z values for
x = [x_min:dd:x_max];
y = [y_min:dd:y_max];
[xx, yy] = meshgrid(x, y);
z = evaluate2d(g, xx, yy);

% Create the figure
p = surf(xx,yy,z);

% Modify the figure's properties
p.EdgeColor = 'none';
ax = p.Parent;

ax.XLim = [x_min, x_max];
ax.YLim = [y_min, y_max];
ax.ZLim = [0,max(z,[],'all')*(1 + 1/5)];

xlabel('x')
ylabel('y')
zlabel('z')

ax.DataAspectRatioMode = 'manual';
ax.DataAspectRatio = [1,1,zar];

caxis([min(z,[],'all'),max(z,[],'all')])
colormap parula
