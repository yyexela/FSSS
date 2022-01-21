function plot2d(f, x_min, x_max, y_min, y_max)

% Get the x and y values we'll be plotting
x = linspace(x_min,x_max,100);
y = f(x);

% Create the plot
p = plot(x,y);

% Modify the plot's properties
ax = p.Parent;
ax.XLim = [x_min, x_max];
ax.YLim = [y_min, y_max];

xlabel('x')
ylabel('y')