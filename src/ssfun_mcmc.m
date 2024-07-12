function ss = ssfun_mcmc(theta,data_for_mcmc,flags)
% cells error.

time   = data_for_mcmc.xdata;
cells  = data_for_mcmc.ydata;


% assign parameters.
mu_max = theta(1);
Ks = theta(2);


if flags.logNormal == 1
Qn = 10.^theta(3);
N0 = 10.^theta(4);
end




% Initial conditions
y0 = [N0, cells(1)];

% Time span
tspan = time;

%without the non-negative this problem will lead to an infeasible solution.
opts = odeset('RelTol',1e-2,'AbsTol',1e-5,'NonNegative',1);

% Solve the ODE
[~, ymodel] = ode45(@(t, y) growth_ode(t, y, mu_max, Ks, Qn), tspan, y0,opts);


if flags.logtransformed == 1
    ss = sum((log(ymodel(:,2))/log(10) - log(cells)/log(10)).^2);
else
    ss = sum((ymodel(:,2) - cells).^2);
end



end
