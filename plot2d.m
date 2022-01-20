% Obtain the function we'll be plotting
x_offset = 5.4;
x_scale = 1.7;
y_offset = 2;
y_scale = 5;
f = gaussian(x_offset, x_scale, y_offset, y_scale);

% Get the x and y values we'll be plotting
x = linspace(x_offset - x_scale * 4, x_offset + x_scale * 4,100);
y = f(x);

% Create the plot
p = plot(x,y);

% Modify the plot's properties
ax = p.Parent;
ax.XLim = [x_offset - x_scale * 4, x_offset + x_scale * 4];
ax.YLim = [0,max(y)+max(y)/5];