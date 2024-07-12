
function dydt = growth_ode(t, y, mu_max, Ks, Qn)
    % Unpack the state variables
    N = y(1);
    P = y(2);
    


    dydt = [-Qn * ((mu_max * N) / (N + Ks) )* (P * 1e6);  P * (mu_max * N) / (N + Ks)];
end
