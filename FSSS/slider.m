Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
f = figure;
pan = uipanel(f,'Position',Newpos);
c = uicontrol(pan,'Style','slider','Position',[0,0,1,1]);
c.Units = 'normalized';
c.Position = [0,0,1,1];
c.Callback = @redraw;
c.Min = 0;
c.Max = 360;

s = [210 -25];
k = [.65 .4 .3 10];
p = surfl(xx,yy,z, s, k);

colormap bone
shading interp

% Modify the figure's properties
p.EdgeColor = 'none';
ax = p.Parent;

max_z = max(z,[],'all', 'omitnan');
min_z = min(z,[],'all', 'omitnan');
diff_z = max_z - min_z;

ax.XLim = [min(x), max(x)];
ax.YLim = [min(y), max(y)];
ax.ZLim = [min_z-diff_z*(1/5),max_z+diff_z*(1/5)];

xlabel('x (mm)')
ylabel('y (mm)')
zlabel('h (mm)')

ax.DataAspectRatioMode = 'manual';
ax.DataAspectRatio = [1,1,zar];
ax.FontSize = 12;

function redraw(src, event)
    disp(src.Value)
    pan = src.Parent;
    f = pan.Parent;
    f(1,1)
end