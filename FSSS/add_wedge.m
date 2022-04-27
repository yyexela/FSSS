function [h] = add_wedge(h_old, map, wedge_h)
% Returns the displacement field where every NaN in vx and vy are 0
%   Input:
%     h_old:    The original surface height
%     map:      A matrix same dimensions as h_old with NaN values where the wedge is
%     wedge_h:  Wedge height
%   Output:
%     h:        The updated surface height

h = h_old;

for i=1:size(map,1)
    for j=1:size(map,2)
        if isnan(map(i,j))
            h(i,j) = wedge_h;
        end
    end
end