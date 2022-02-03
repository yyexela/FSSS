function [h] = fsss(dr, np, n, hp, H)
% Calculates the surface height following the equations in Moisy's paper
%   Input:
%     dr:       A struct containing the x and y components of the
%               displacement field as two separate matrices (like the
%               output of meshgrid)
%     np:       The pattern-side index of refraction (1.333 for water)
%     n:        The camera-side index of refraction (1.000 for air)
%     hp:       The height of the liquid at rest
%     H:        The camera-pattern distance
%     
%   Output:
%     h:        The calculated height at each gradient vector

% Calculate constants from FSSS paper
alpha = 1-n/np;                  % Equation (1)
factor = 1/(alpha * hp) - 1/H;   % Equation (13)

% Get the proper height scaling
scale = abs(dr.x(1) - dr.x(2));

fprintf('factor is %f\n', -factor)
fprintf('scale is %f\n', scale)

% Find the gradient (just above equation (18))
xi = dr;
xi.vx = -xi.vx*factor;
xi.vy = -xi.vy*factor;

% Verivy np > n
if ~(np > n)
    ME = MException('fsss:InvalidParameters','np (%f) needs to be less than n (%f)', np, n);
    throw(ME)
end

% Verivy factor = 1/h_star > 0
if ~(factor > 0)
    ME = MException('fsss:InvalidParameters','factor (1/h_star) = %f is not strictly positive', factor);
    throw(ME)
end

% Solve for the surface height
h = hp + intgrad2(xi.vx, xi.vy, scale, scale); % Equation (18)
