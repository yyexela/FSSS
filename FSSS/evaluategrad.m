function [z] = evaluategrad(f_name, vx, vy)
% Returns the z-values of the 2D function g evalated at each gradient
% vector vx,vy are 2D matrices for the gradient field
%   Input:
%     f_name:   The function used to evaluate the gradient field
%     vx:       A 2D matrix containing x-components of a gradient field
%     vy:       A 2D matrix containing y-components of a gradient field
%   Output:
%     z:        A matrix containing the final value from g at each vector

% Verify matrices are the same size
if ~(isequal(size(vx), size(vy)))
    ME = MException('evaluategrad:InvalidParameters','Matrix vx and vy must be the same size');
    throw(ME)
end

% Function we'll be using to evaluate the gradient field, 'norm' by default
g = @(x,y) (x.^2 + y.^2).^(1/2);

if isequal(f_name, 'rad')
    g = @custom_angle;
end

% Create the output matrix
z = zeros(size(vx));

% Obtain the values of z for every vx and vy combination
for i = 1:size(vx,1)
    for j = 1:size(vx,2)
        z(i,j) = g(vx(i,j), vy(i,j));
    end
end
