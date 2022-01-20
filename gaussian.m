function [f] = gaussian(x_offset, x_scale, y_offset, y_scale)
% Gaussian curve function with modifying parameters
%   Input:
%     x:        Input values to the function as an array
%     x_offset: Shift the curve x units to the right
%     x_scale:  Change the x-axis scale (larger = stretching)
%     y_offset: Shift the curve x units up
%     y_scale:  Change the y-axis scale (larger = stretching)
%   Output:
%     f:        A gaussian curve function converting an array x to an 
%               output array y

f = @(x) y_scale*exp(-((x-x_offset)/x_scale).^2)+y_offset;