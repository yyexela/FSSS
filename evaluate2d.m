function [z] = evaluate2d(g, x, y)
% Returns the z-values of the 2D function g evalated at x and y
% where x,y can be vectors or 2D matrices from meshgrid
%   Input:
%     g:        A 2D function
%     x:        The x-coordinates to evaluate (either a vector or matrix)
%     y:        The y-coordinates to evaluate (either a vector or matrix)
%   Output:
%     z:        A matrix containing the final x and y values

% Transform x and y into a meshgrid output if needed
[xx, yy] = getmeshgrid(x, y);

% Create the output matrix
z = zeros(size(xx));

% Obtain the values of z for every x and y combination
for i = 1:size(xx,1)
    for j = 1:size(xx,2)
        z(i,j) = g(xx(i,j), yy(i,j));
    end
end