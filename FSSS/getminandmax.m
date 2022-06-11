function [min_val, min_idx, max_val, max_idx] = getminandmax(z)
% Given height values z, return the min and max values and indices
%   Input:
%     z:        Array containing height values we want the min/max for
%   Output:
%     min_val:  Minimum value from pks
%     min_idx:  Index of minimum value from locs
%     max_val:  Maximum value from pks
%     max_idx:  Index of maximum value from locs

[pks, locs] = findpeaks(z);
max_idx = locs(1);
max_val = pks(1);
min_idx = locs(1);
min_val = pks(1);
for i = locs.'
    if max_val < z(i)
        max_idx = i;
        max_val = z(i);
    end
    if min_val > z(i)
        min_idx = i;
        min_val = z(i);
    end
end
