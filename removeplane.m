function hf = removeplane(h)
% Remove the plane of best fit from the surface height
%   Input:
%     h:        A 2D matrix containing height values
%   Output:
%     hf:       The final 2D matrix containing height values
%               after subtracting the plane of best fit

% Calculate plane of best fit using the four corners of the image 
% Extract the four corners of the surface (bottom left going clockwise)
rows = size(h,1);
cols = size(h,2);
x = [1; 1;    rows; rows];
y = [1; cols; cols; 1];
z = [h(1,1); h(1,cols); h(rows,cols); h(rows,1)];
plane = fit([x,y],z,'poly11');

plot(plane,[x,y],z); % Plot the points and the plane
hold on
surf(h);
hold off

havg = quad2d(plane,1,rows,1,cols)./(rows*cols);

% Create new surface by subtracting the plane from the original surface
% making sure to add the average height removed
h_new = h;
for i = 1:rows
    for j = 1:cols
        h_new(i,j) = h_new(i,j) - plane(i,j) + havg;
    end
end

hf = h_new;