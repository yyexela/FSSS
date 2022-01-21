function plotcontour(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)

% Get the x and y coordinates we want the z values for
x = (x_min:dd:x_max);
y = (y_min:dd:y_max);
[xx, yy] = meshgrid(x, y);
z = evaluate2d(g, xx, yy);

% Calculate the gradient numerically
[gxx,gyy] = gradient(z,dd);

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
quiver(xx,yy,split(gxx,n),split(gyy,n),scale)
hold off