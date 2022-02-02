function [m1] = split(m0,n)
% Given a matrix, set every row and column that isn't a multiple of n
% to 0, this removes (n^2-1)/n^2 of the data in the matrix
% (This is useful for plotting the gradient on a contour plot)
%   Input:
%     m0:        Input 2D matrix
%     n:         Set n^2-1 of the original data to 0
%   Output:
%     m1:        The output matrix after data removal
m1 = m0;
for i=1:size(m1,1)
    for j=1:size(m1,2)
        if mod(i,n) ~= 0 || mod(j,n) ~= 0
            m1(i,j) = 0;
        end
    end
end