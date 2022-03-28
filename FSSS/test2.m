%a = [2 1 3 4];
%b = [-5 -10 -20 -30];
%F = @(x)log(x.^a)-x-b;
%x0 = [1  1  1  1];
%x = fsolve(F,x0,optimset('Display','none'));

a = [1,3,2,4;5,7,6,8];
a = reshape(a, [2,2,2]);
b = [-5,-10,-15,-20;-25,-30,-35,-40];
b = reshape(b, [2,2,2]);
F = @(x)x.*a-b;
x0 = ones(2,2);
x = fsolve(F,x0,optimset('Display','none'));