% The main script used for plotting and calculating everything

% Properties:
% * What to plot:
%    'plot_2d', 'plot_3d', 'plot_contour', 'fsss_analytic', 'fsss_numeric'
%    'displacement_field', 'fsss_numeric_contour', 'fsss_analytic_contour'
plot_type = 'displacement_field';
% * General plot properties:
dd = 0.1;         % dd:     the step between min and max of x and y
x_min = 0;        % x_min:  lower bound on the x axis to graph
x_max = 60;       % x_max:  upper bound on the x axis to graph
y_min = 0;        % y_min:  lower bound on the y axis to graph
y_max = 40;       % y_max:  upper bound on the y axis to graph
% * plot3d properties:
zar = .05;        % zar:    z-axis aspect ratio (0.05 for numeric, 1 else)
% * plotcontour properties:
scale = 8;        % scale:  adjusts the length of the gradient arrows
vecnum = 20;      % vecnum: approximate # of gradient vectors along an axis
% * fsss_* properties:
np = 1.333;       % np:     Pattern-side index of refraction (1.333 water)
n = 1;            % n:      Camera-side index of refraction (1.000 air)
hp = 2;           % hp:     The height of the liquid at rest
H = 1000;         % H:      The camera-pattern distance
% * displacement_field properties
v_mode = 'rad';   % v_mode: Type of plot to show (ie: 'rad' or 'norm')
scalearrow = 10;  % adjusts the length of superimposed arrows
spacing = 15;     % Set to 0 for no arrows
% * fsss_* and displacement_field shared properties:
tpose1 = 0;       % tpose1:  Transpose the gradient field vectors
                  %          after loadvec() (numeric)
neg1 = 0;         % neg1:    Multiply the gradient field by -1 (numeric)
tpose2 = 0;       % tpose2:  Transpose the gradient field vectors
                  %          after getdr() (analytic)
neg2 = 0;         % neg2:    Multiply the gradient field by -1 (analytic)

% Function properties and definitions (f(x) is 1D, g(x,y) is 2D):
% * Gaussian function parameters used in @gaussian
x_offset_g = 5.4;
x_scale_g = 1.7;
y_offset_g = 2;
y_scale_g = 5;

% * Sin function parameters used in sin
x_offset_s = 0;
x_scale_s = 1.2;
y_offset_s = 2;
y_scale_s = 1/2;

% * Define the functions used
%f = gaussian(x_offset_g, x_scale_g, y_offset_g, y_scale_g);
f = @(x) y_scale_s*sin((x-x_offset_s)/(x_scale_s)) + y_offset_s;
g = planewave1(f, 'y');
%g = radialwave1(f);

% Run the specified plot_type
if isequal(plot_type,'plot_contour')
    plotcontouranalytic(g, x_min, x_max, y_min, y_max, dd, vecnum, scale)
elseif isequal(plot_type,'plot_2d')
    plot2d(f, x_min, x_max, y_min, y_max)
elseif isequal(plot_type,'plot_3d')
    plot3danalytic(g, x_min, x_max, y_min, y_max, dd, zar)
elseif isequal(plot_type,'fsss_analytic') || ...
        isequal(plot_type,'fsss_numeric') || ...
        isequal(plot_type,'fsss_numeric_contour') || ...
        isequal(plot_type,'fsss_analytic_contour') || ...
        isequal(plot_type,'displacement_field')
    
    if isequal(plot_type,'fsss_analytic') || ...
            isequal(plot_type, 'fsss_analytic_contour')
        % Calculate the displacement field from g
        dr = getdr(g, x_min, x_max, y_min, y_max, dd, np, n, hp, H);

        if tpose2
            % Flip fx and fy due to loadvec
            dr.vx = transpose(dr.vx);
            dr.vy = transpose(dr.vy);
            tmp = dr.x;
            dr.x = dr.y;
            dr.y = tmp;
        end
        
        if neg2
            dr.vx = -dr.vx;
            dr.vy = -dr.vy;
        end
        
        % Update the x and y coordinates
        x = dr.x;
        y = dr.y;
    else
        % Import the data
        dr = loadvec("openpiv_plane.txt");
        
        if tpose1
            % Flip x and y due to loadvec
            dr.vx = transpose(dr.vx);
            dr.vy = transpose(dr.vy);
        else
            % If we're not transposing, make sure x is the change in
            % columns and y is the change in rows
            tmp = dr.x;
            dr.x = dr.y;
            dr.y = tmp;
        end
        
        if neg1
            % For testing to see what happens
            dr.vx = -dr.vx;
            dr.vy = -dr.vy;
        end
        
        % Update the x and y coordinates
        x = dr.x;
        y = dr.y;
    end
    
    % Run the fsss equations
    h = fsss(dr, np, n, hp, H, dd);
    
    % Make the plot
    if isequal(plot_type, 'displacement_field')
        %showf(dr,v_mode,'scalearrow',scalearrow,'spacing',spacing);
        if isequal(v_mode, 'rad')
            % Calculate the angle in radians of each gradient vector
            z = evaluategrad('rad', dr.vx, dr.vy);
        elseif isequal(v_mode, 'norm')
            % Calculate the magnitude of each gradient vector
            z = evaluategrad('norm', dr.vx, dr.vy);
        end
        
        % Make the plot
        plot3dnumeric(z, x ,y, min(x), max(x), min(y), max(y), zar)
        
        % Change the viewing angle
        view(0,90)
        
    elseif isequal(plot_type, 'fsss_analytic') || ...
           isequal(plot_type, 'fsss_numeric')
        plot3dnumeric(h, x ,y, min(x), max(x), min(y), max(y), zar)
    elseif isequal(plot_type, 'fsss_numeric_contour') || ...
            isequal(plot_type, 'fsss_analytic_contour')
        plotcontournumeric(h, x, y, dd, vecnum, scale)
    end
end