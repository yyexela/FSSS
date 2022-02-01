function drf = removemean(dr)
% Subtract the mean displacement field
%   Input:
%     dr:       An input displacement field
%   Output:
%     drf:      The displacement field with the mean subtracted

mean_x = mean(dr.vx, 'all');
mean_y = mean(dr.vy, 'all');

drf = dr;

drf.vx = arrayfun(@(x) x - mean_x, dr.vx);
drf.vy = arrayfun(@(y) y - mean_y, dr.vy);