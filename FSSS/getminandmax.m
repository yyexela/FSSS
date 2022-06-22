function [min_val, min_idx, max_val, max_idx] = getminandmax(z)
% Given height values z, return the min and max values and indices
%   Input:
%     z:        Array containing height values we want the min/max for
%   Output:
%     min_val:  Minimum value from pks (-1 if no peaks)
%     min_idx:  Index of minimum value from locs (-1 if no peaks)
%     max_val:  Maximum value from pks (-1 if no peaks)
%     max_idx:  Index of maximum value from locs (-1 if no peaks)

[pks, locs] = findpeaks(z);
% Make sure we're getting peaks
if isequal(size(pks), [1,0])
    max_idx = -1;
    max_val = -1;
    min_idx = -1;
    min_val = -1;
else
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
end