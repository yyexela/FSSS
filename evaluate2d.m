function [z] = evaluate2d(f, x, y)
% Returns the z-values of the 2D function f evalated at x and y
% where x,y can be vectors or 2D matrices from meshgrid
%   Input:
%     f:        A 2D function
%     x:        The x-coordinates to evaluate (either a vector or matrix)
%     y:        The y-coordinates to evaluate (either a vector or matrix)
%   Output:
%     z:        A matrix containing the final x and y values

% Make sure that we are working with two matrices
x_rows = size(x,1);
x_cols = size(x,2);
y_rows = size(y,1);
y_cols = size(y,2);

% Verify we either have two matrices of the same size or two vectors
if (x_rows == 1 && y_rows ~= 1) || (y_rows == 1 && x_rows ~= 1)
    ME = MException('evaluate3d:MismatchedInput','x and y must either both be vectors or matrices',axis);
    throw(ME)
elseif x_rows ~= 1 && y_rows ~= 1 && ~isequal(size(x), size(y))
    ME = MException('evaluate3d:MismatchedInput','x and y must match in size if they''re matrices',axis);
    throw(ME)
end

% Ensure that xx and yy are two matrices of the same size
xx = x;
yy = y;
z = zeros(size(xx));

if x_rows == 1 && y_rows == 1
    [xx, yy] = meshgrid(xx, yy);
end

% Obtain the values of z for every x and y combination
for i = 1:size(xx,1)
    for j = 1:size(xx,2)
        z(i,j) = f(xx(i,j), yy(i,j));
    end
end