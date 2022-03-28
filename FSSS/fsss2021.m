function F = fsss2021(h, n, np, beta, dr2)

[gh_x, gh_y] = gradient(h);
gh = [gh_x, gh_y];
gh = reshape(gh, size(gh_x,1), size(gh_x,2), []);

beta_tmp = [beta.vx, beta.vy];
beta = reshape(beta_tmp, size(beta.vx,1), size(beta.vx,2), []);

dr2_tmp = [dr2.vx, dr2.vy];
dr2 = reshape(dr2_tmp, size(dr2.vx,1), size(dr2.vx,2), []);

F = h.*(1-n/np).*(gh-beta)-dr2; % Equation (2)

% dr2.vx
% dr2.vy