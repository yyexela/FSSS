function [f] = planewave1(g, axis)
% Create a 2D function by stretching g along an axis
%   Input:
%     g:        A 1D function
%     axis:     The axis to stretch along (either 'x' or 'y')
%   Output:
%     f:        The 1D function g stretched along the y-axis
%               (can only be evaluated at a single point until I'm
%                better at MATLAB, to evaluate at multiple discrete
%                points use with evaluate2d)

if isequal(axis,'x')
    f = @(x,y) g(y);
elseif isequal(axis,'y')
    f = @(x,y) g(x);
else
    ME = MException('planewave1:NoSuchAxis','Axis ''%s'' is invalid, please use either ''x'' or ''y''',axis);
    throw(ME)
end
