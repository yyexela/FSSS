% The main script used for plotting and calculating everything
% Note: To save the figure, run `print(gcf,'foo.png','-dpng','-r600')`

% Properties:
% * What to plot:
%    'plot_2d', 'plot_3d', 'plot_contour', 'fsss_analytic', 'fsss_numeric'
%    'displacement_field', 'fsss_numeric_contour', 'fsss_analytic_contour'
%    'fsss_pivmat'
plot_type = 'fsss_numeric';
% * General plot properties: 
dd = 0.1;         % dd:      The step between min and max of x and y
x_min = 0;        % x_mixn:  Lower bound on the x axis to graph
x_max = 60;       % x_max:   Upper bound on the x axis to graph
y_min = 0;        % y_min:   Lower bound on the y axis to graph
y_max = 40;       % y_max:   Upper bound on the y axis to graph
% * plot3d properties:
zar = .05;        % zar:     Z-axis aspect ratio
% * plotcontour properties:
scale = 8;        % scale:   Adjusts the length of the gradient arrows
vecnum = 20;      % vecnum:  Approx. # of gradient vectors along an axis
% * fsss_* properties:
                  % filenm:  Name of the vector field file from OpenPIV
filenm = "s15_m15";
                  % raw_img: Used in get_map for wedge location
raw_img = "../../Experiment 12/trial 2/cropped/moving/15.JPG";
seconds = 15;
%    * Experimental values
ppmm = 17.3322;   % ppmm:    Pixels per millimeter in used in OpenPIV
np = 1.333;       % np:      Pattern-side index of refraction
                  %          (1.33 water 1.49 acrylic, 1.56 glass)
n = 1;            % n:       Camera-side index of refraction (1.000 air)
h0 = 4-(1/10)*seconds;         % hp:      The height of the liquid at rest (mm)
                  %          (For numeric FSSS this is recalculated to be
                  %          the effective water height)
                  %          When < 0, set h0 so minimum is zero
H = 1330;         % H:       The camera-pattern distance (mm)
%    * Used to calculate effective water height
hg = 5.5;         % hg:      Bottom layer height (mm)
ng = 1.49;        % ng:      Bottom layer index of refraction
                  %          (1.33 water 1.49 acrylic, 1.56 glass)
%    * Processing options
rm_m_d = 1;       % rm_m_d:  Subtract the mean displacement field before
                  %          FSSS integration
rm_pln = 0;       % rm_pln:  Subtract the plane of best fit (performed
                  %          after rm_m_d)
avg_h = 0;        % avg_h:   Ensure average height is h0 (used in numeric
                  %          FSSS when effective water height is used)
min_h = 1;        % min_h:   Ensure minimum height is at least 0
ups_h = 1;        % ups_h:   Set upstream height to h0
% * displacement_field properties
v_mode = 'norm';  % v_mode:  Type of plot to show (ie: 'rad' or 'norm')
s_arrow = 10;     % s_arr:   adjusts the length of superimposed arrows
space = 15;       % space:   Set to 0 for no arrows
% * fsss_* and displacement_field shared properties:
tpose1 = 1;       % tpose1:  Transpose the gradient field vectors
                  %          after loadvec() (numeric)
neg1 = 0;         % neg1:    Multiply the gradient field by -1 (numeric)
swapgxy = 1;      % swapgxy: Make sure increeasing row/column increases x/y
                  %          after loadvec() (numeric)
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
elseif isequal(plot_type, 'fsss_pivmat')
    % Calculate effective water height
    hp = h0 + (np./ng).*hg; % Equation (14)
    
    % Load displacement field
    dr = loadvec(filenm + ".txt");
    
    dr.vy = swapcols(dr.vy);
    dr.vx = swapcols(dr.vx);
    
    % Replacing NaN with 0
    dr = replace_nan(dr);
    
    if rm_m_d
        fprintf("Subtracting mean displacement field\n")
        dr = removemean(dr);
    end
    
    h = surfheight(dr, hp, H, np, 'test', 'submean');
    
    % Remove layer between water and pattern
    h.w = arrayfun(@(z) z - hg, h.w);
    
    showf(h, 'surf');
elseif isequal(plot_type,'fsss_analytic') || ...
        isequal(plot_type,'fsss_numeric') || ...
        isequal(plot_type,'fsss_numeric_contour') || ...
        isequal(plot_type,'fsss_analytic_contour') || ...
        isequal(plot_type,'displacement_field')
    
    if isequal(plot_type,'fsss_analytic') || ...
            isequal(plot_type, 'fsss_analytic_contour')
        % Analytic FSSS
        
        % Set the water height
        hp = h0;
        
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
        % Numeric FSSS
        
        % Calculate effective water height
        hp = h0 + (np./ng).*hg; % Equation (14)
        
        % Import the data
        dr = loadvec(filenm + ".txt");
        
        if tpose1
            % Flip x and y due to loadvec
            fprintf("Transposing displacement field\n")
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
            fprintf("Negative every element of displacement field\n")
            dr.vx = -dr.vx;
            dr.vy = -dr.vy;
        end
        
        if swapgxy
            % Swap positions of rows for the gradient matrices
            fprintf("Swapping rows of displacement field\n")
            dr.vx = swaprows(dr.vx);
            dr.vy = swaprows(dr.vy);
        end
        
        % Update the x and y coordinates
        x = dr.x;
        y = dr.y;
    end
    
    if rm_m_d
        fprintf("Subtracting mean displacement field\n")
        dr = removemean(dr);
    end
    
    % Make a copy of dr to use in FSSS, replacing NaN with 0, but using NaN
    % dr to add wedge heights to final surface height
    dr_map = dr;
    dr = replace_nan(dr);
    
    % Run the fsss equations
    h = fsss(dr, np, n, hp, H);
    % Remove layer between water and pattern
    h = arrayfun(@(z) z - hg, h);
    
    if rm_pln
        fprintf("Subtracting plane of best fit\n")
        h = removeplane(h);
    end
    if avg_h || min_h || ups_h
        if avg_h
            fprintf("Adjusting surface height so the average height is h0 (%f mm)\n", h0)
        end
        if min_h
            fprintf("Adjusting surface height so the minimum height is at least zero\n")
        end
        if ups_h
            fprintf("Adjusting surface height so the upstream water height is h0 (%f mm)\n", h0)
        end
        h = adjustheight(h, h0, avg_h, min_h, ups_h);
    end
    
    % Get NaN values from where raw_img is red, NaN values used to create
    % wedge in surface reconstruction
    if ~isequal(raw_img, '')
        map = get_map(dr, raw_img, ppmm); % See get_map for JPG/PNG differences
        wedge_h = max(h,[],'all', 'omitnan'); % Wedge height is max water height
        h = add_wedge(h, map, wedge_h);
    end
    
    % Make the plot
    if isequal(plot_type, 'displacement_field')
        %showf(dr,v_mode,'s_arrow',s_arrow,'space',space);
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
else
    fprintf("Error: %s \'%s\'\n", "Invalid Option", plot_type)
end
