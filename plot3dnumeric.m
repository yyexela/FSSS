function plot3dnumeric(z, x_min, x_max, y_min, y_max, dd, zar)
% Plots the z-values on a cube whose base has corners (x_min,x_max)
% and (y_min,y_max)
%   Input:
%     z:        The 2D array containing z-values
%     x:        either a vector or matrix of x-values
%     y:        either a vector or matrix of y-values
%   Output:
%     None

% Get the x and y coordinates we want the z values for
x = (x_min:dd:x_max);
y = (y_min:dd:y_max);
[xx, yy] = meshgrid(x, y);

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
