% Path of OpenPIV's output
path = "openpiv.txt";

% Load OpenPIV's output file
dr = loadvec(path);

% Adjust after import due formatting inconsistency (see DLA Report 9)
dr.vy = swapcols(dr.vy);
dr.vx = swapcols(dr.vx);

% Calculating hp (effective water height)
h0 = 8;     % top layer height (mm)
np = 1.333; % top layer index of refraction
            % (1.33 water 1.49 acrylic, 1.56 glass)
hg = 5;     % bottom layer height
ng = 1.56;  % bottom layer index of refraction

hp = h0 + (np./ng).*hg;

% Remove slope
dr = removemean(dr);

% Get FSSS Height and set the average height to what we expect
h = surfheight2(dr, hp, 890, np);
h.w = adjustheight(h.w, h0);

% Plot the height
showf(h, 'Surf')
%subplot(1,2,1), showf(h, 'Surf')
%subplot(1,2,2), showf(h)

colormap jet