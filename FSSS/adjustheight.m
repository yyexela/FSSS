function hf = adjustheight(h, h0, avg_h, min_h, ups_h)
% Update the input height value based on various settings
% expected, h0
%   Input:
%     h:        A 2D matrix containing height values
%     adj_h:    Set the average height to h0
%     min_h:    Set the minimum height to at least 0
%   Output:
%     hf:       The final 2D matrix containing height values
%               whose average height is hp

hf = h;

if avg_h
    havg = sum(h,'all')/(size(h,1)*size(h,2)); % Average height
    diff = h0-havg;

    hf = arrayfun(@(z) z + diff, hf);          % Update heights
end

if min_h && ups_h
    val = hf(floor(size(h,1)/2),1); % Upstream surface height
    hmin = min(hf, [], 'all'); % Minimum surface height
    want_ups = h0;
    want_min = max(0,hmin); % If hmin < 0, add its negative to surface height
    scale = (want_ups-want_min)/(val-hmin); % Scaling factor
    
    hf = arrayfun(@(z) z - val, hf); % Set upstream to zero
    hf = arrayfun(@(z) z * scale, hf);     % Scale height
    hf = arrayfun(@(z) z + want_ups, hf); % Set upstream back to what it was
    return
end

if min_h
    hmin = min(hf, [], 'all'); % Minimum surface height
    want_min = min(0,hmin); % If hmin < 0, add its negative to surface height
    hf = arrayfun(@(z) z - want_min, hf);
end

if ups_h
    val = hf(floor(size(h,1)/2),1); % Upstream surface height
    diff = h0 - val;
    
    hf = arrayfun(@(z) z + diff, hf); % Update heights
end