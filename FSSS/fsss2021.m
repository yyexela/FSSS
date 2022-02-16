function F = fsss2021(h, n, np, beta, dr2)

F(1) = h.*(1-n/np).*(gradient(h)-beta.vx)./dr2.vx; % Equation (2)
F(2) = h.*(1-n/np).*(gradient(h)-beta.vy)./dr2.vy; % Equation (2)