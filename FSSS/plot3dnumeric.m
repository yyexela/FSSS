function plot3dnumeric(z, x, y, x_min, x_max, y_min, y_max, zar)
% Plots the z-values on a cube whose base has corners (x_min,x_max)
% and (y_min,y_max)
%   Input:
%     z:        The 2D array containing z-values
%     x:        Either a vector or matrix of x-values
%     y:        Either a vector or matrix of y-values
%     x_min:    The lower bound on the x-axis of the graph
%     x_max:    The upper bound on the x-axis of the graph
%     y_min:    The lower bound on the y-axis of the graph
%     y_max:    The upper bound on the y-axis of the graph
%   Output:
%     None

% Transform x and y into a meshgrid output if needed
[xx, yy] = getmeshgrid(x, y);

% Create the figure
p = surf(xx,yy,z);

% Modify the figure's properties
p.EdgeColor = 'none';
ax = p.Parent;

max_z = max(z,[],'all');
min_z = min(z,[],'all');
diff_z = max_z - min_z;

ax.XLim = [x_min, x_max];
ax.YLim = [y_min, y_max];
ax.ZLim = [min_z-diff_z*(1/5),max_z+diff_z*(1/5)];

xlabel('x (mm)')
ylabel('y (mm)')
zlabel('h (mm)')

ax.DataAspectRatioMode = 'manual';
ax.DataAspectRatio = [1,1,zar];
ax.FontSize = 12;

colorbar;

caxis([min(z,[],'all'),max(z,[],'all')])
colormap jet
