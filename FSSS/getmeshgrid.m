function [xx, yy] = getmeshgrid(x,  y)
% Returns the a meshgrid of vectors x and y. If x and y are already the
% output of a meshgrid, return them unchanged.
%   Input:
%     x:        either a vector or matrix
%     y:        either a vector or matrix
%   Output:
%     xx:       A matrix, either the output of meshgrid(x,y) or x unchanged
%     yy:       A matrix, either the output of meshgrid(x,y) or y unchanged

% Make sure that we are working with two matrices
x_rows = size(x,1);
y_rows = size(y,1);

% Verify we either have two matrices of the same size or two vectors
if (x_rows == 1 && y_rows ~= 1) || (y_rows == 1 && x_rows ~= 1)
    ME = MException('getmeshgrid:MismatchedInput','x and y must either both be vectors or matrices');
    throw(ME)
elseif x_rows ~= 1 && y_rows ~= 1 && ~isequal(size(x), size(y))
    ME = MException('getmeshgrid:MismatchedInput','x and y must match in size if they''re matrices');
    throw(ME)
end

% Ensure that xx and yy are two matrices of the same size
xx = x;
yy = y;

if x_rows == 1 && y_rows == 1
    [xx, yy] = meshgrid(xx, yy);
end