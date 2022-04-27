function [dr] = replace_nan(dr_old)
% Returns the displacement field where every NaN in vx and vy are 0
%   Input:
%     dr_old:   The displacement field
%   Output:
%     dr:       Updated displacement field

dr = dr_old;

for i=1:size(dr.vx,1)
    for j=1:size(dr.vx,2)
        if isnan(dr.vx(i,j))
            dr.vx(i,j) = 0;
            dr.vy(i,j) = 0;
        end
    end
end