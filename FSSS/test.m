fun = @(x)x*x*x - [1,2;3,4];
x0 = ones(2);
fsolve(fun,x0)
try
    options = optimoptions('fsolve','Display','off');
    [x,fval,exitflag,output] = fsolve(fun,x0,options)
catch ME
    fprintf("%s\n",ME.message)
    throw(ME)
end

return

a = 1;
b = 2;
c = 3;
d = 4;

x0 = ones(2);

fun = @(x) fun_wrap(x,a,b,c,d);

options = optimoptions('fsolve','Display','off');

[x,fval,exitflag,output] = fsolve(fun, x0);

function y = fun_wrap(x,a,b,c,d)
    y = x*x*x - [a,b;c,d];
end