function [dr] = getdr(g, x_min, x_max, y_min, y_max, dd, np, n, hp, H)
% Returns the displacement field given an input function g
%   Input:
%     g:        A 2D function
%     x:        The x-coordinates to evaluate (either a vector or matrix)
%     y:        The y-coordinates to evaluate (either a vector or matrix)
%     np:       The pattern-side index of refraction (1.333 for water)
%     n:        The camera-side index of refraction (1.000 for air)
%     H:        The camera-pattern distance
%   Output:
%     None

% Get the x and y coordinates as a meshgrid
x = (x_min:dd:x_max);
y = (y_min:dd:y_max);
[xx, yy] = meshgrid(x, y);

% Calculate constants from FSSS paper
alpha = 1-n/np;                  % Equation (1)
factor = 1/(alpha * hp) - 1/H;   % Equation (13)
h_star = 1/factor;

% Verify factor = 1/h_star > 0
if ~(factor > 0)
    ME = MException('getdr:InvalidParameters','factor (1/h_star) = %f is not strictly positive', factor);
    throw(ME)
end

% Calculate the surface heights
z = evaluate2d(g, xx, yy);

% Calculate the gradient
[gxx,gyy] = gradient(z,dd);

% Equation (13) in the FSSS paper to get the displacement field from the
% gradient
dr = struct;
dr.vx = -gxx*h_star;
dr.vy = -gyy*h_star;