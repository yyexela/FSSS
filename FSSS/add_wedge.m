function [h] = add_wedge(h_old, dr_map, wedge_h)
% Returns the displacement field where every NaN in vx and vy are 0
%   Input:
%     h_old:    The original surface height
%     dr_map:   The displacement field with NaN values where the wedge is
%     wedge_h:  Wedge height
%   Output:
%     h:        The updated surface height

h = h_old;

for i=1:size(dr_map.vx,1)
    for j=1:size(dr_map.vx,2)
        if isnan(dr_map.vx(i,j))
            h(i,j) = wedge_h;
        end
    end
end