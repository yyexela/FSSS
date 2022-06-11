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
for i=1:size(locs,2)
    idx = locs(i);
    if max_val < z(idx)
        max_idx = idx;
        max_val = z(idx);
    end
    if min_val > z(idx)
        min_idx = idx;
        min_val = z(idx);
    end
end
