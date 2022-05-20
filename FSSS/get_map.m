function [map] = get_map(dr, wedge_img_path, ppmm)
% Returns the displacement field where every NaN in vx and vy are 0
%   Input:
%     dr:               The displacement field
%     wedge_img_path:   Path to image with wedge in red (#FF0000)
%     ppmm:             Pixels per millimeter
%   Output:
%     map:              A matrix same size as h with NaN where wedge is

% Recall that our y values in the matrix are rows and x values are cols
map = zeros(size(dr.vx));
img = imread(convertStringsToChars(fullfile(wedge_img_path)));
scalex = dr.x(2) - dr.x(1); % mm between matrix positions in x
scaley = dr.y(2) - dr.y(1); % mm between matrix positions in y

for i=1:size(map,1)
    for j=1:size(map,2)
        % Calculate pixel position in img from physical quantities
        r = floor((dr.y(1)+scaley*(i-1))*ppmm);% Pixel column position
        c = floor((dr.x(1)+scalex*(j-1))*ppmm);% Pixel row position
        % 254 for JPG 255 for PNG
        if img(r,c,1) >= 254 && img(r,c,2) == 0 && img(r,c,3) == 0
            map(i,j) = NaN;
        end
    end
end