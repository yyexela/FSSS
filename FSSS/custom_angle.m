function [deg] = custom_angle(x,y)
% Get the angle of a vector with the +x axis in degrees
%   Input:
%     x:    The x-component of the vector
%     y:    The y-component of the vector
%   Output:
%     deg:  The angle in degrees between the vector and the +x axis

% Calculate angle between the two vectors
deg = angle(x+1i*y)*180/pi;
    
% If v2 falls in the 3rd or 4th quadrants, update angle
if deg < 0
    %deg = deg + 360; % Not in use right now
end