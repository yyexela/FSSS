function [m] = swapcols(m1)
% Returns the z-values of the 2D function g evalated at x and y
% where x,y can be vectors or 2D matrices from meshgrid
%   Input:
%     m1:       An input matrix
%   Output:
%     m:        The input matrix but the row positions are reversed

% Get the dimenstions of the input matrix
[nx, ny] = size(m1);

% Create the output matrix
m = zeros(nx, ny);

% Build each successive row
for i = 1:nx
    m(:,i) = m1(:,nx-i+1);
end
