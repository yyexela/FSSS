function hf = adjustheight(h, h0)
% Update the input height value to have average height equal to what is
% expected, h0
%   Input:
%     h:        A 2D matrix containing height values
%   Output:
%     hf:       The final 2D matrix containing height values
%               whose average height is hp

hf = h;

havg = sum(h,'all')/(size(h,1)*size(h,2)); % Average height
diff = h0-havg;

hf = arrayfun(@(z) z + diff, hf);          % Update heights