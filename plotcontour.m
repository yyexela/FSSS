% Various parameters used in this script
dd = 0.1;         % dd:     the step between min and max of x and y
x_min = 0;        % x_min:  lower bound on the x axis to graph
x_max = 60;       % x_max:  upper bound on the x axis to graph
y_min = 0;        % y_min:  lower bound on the y axis to graph
y_max = 40;       % y_max:  upper bound on the y axis to graph
scale = 8;        % scale:  adjusts the length of the gradient arrows
vecnum = 20;      % vecnum: approximate # of gradient vectors along an axis

% Gaussian function parameters used in @gaussian
x_offset = 5.4;
x_scale = 1.7;
y_offset = 2;
y_scale = 5;

% Obtain the function g we'll be plotting
%f = gaussian(x_offset, x_scale, y_offset, y_scale
f = @(x) (1/2)*sin(x/(1.2)) + 2;
g = planewave1(f, 'y');
%g = radialwave1(f);

% Get the x and y coordinates we want the z values for
x = [x_min:dd:x_max];
y = [y_min:dd:y_max];
[xx, yy] = meshgrid(x, y);
z = evaluate2d(g, xx, yy);

% Calculate the gradient numerically
[fxx,fyy] = gradient(z,dd);

% Create the contour plot
p = contour(xx,yy,z);
axx = gca;
axx.DataAspectRatio = [1,1,1];

% Find the first integer n such that min(size(xx))/n <= vecnum
% This is used to cut down on the number of vectors we plot for the
% gradient field, so that we have about vecnum vectors on the shorter axis
n = 1;
while min(size(xx))/n > vecnum
    n = n + 1;
end

% Superimpose the gradient field
hold on
quiver(xx,yy,split(fxx,n),split(fyy,n),scale)
hold off