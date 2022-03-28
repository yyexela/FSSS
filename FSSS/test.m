fun = @(x)x*x*x - [1,2;3,4];

x0 = ones(2);
options = optimoptions('fsolve','Display','off');
[x,fval,exitflag,output] = fsolve(fun,x0,options)
sum(sum(fval.*fval))
