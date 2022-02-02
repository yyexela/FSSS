function [f] = radialwave1(g)
% A 2D function created by rotating the +x part of g around the origin
%   Input:
%     g:        A 1D function
%   Output:
%     f:        The 1D function f rotated around the origin
%               (can only be evaluated at a single point until I'm
%                better at MATLAB, to evaluate at multiple discrete
%                points use with evaluate2d)

f = @(x,y) g((x^2+y^2)^(1/2));
