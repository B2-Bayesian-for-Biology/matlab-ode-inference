clear all;
clc;


%% load data

addpath(genpath("./../"))

data_table = readtable('./../data/in_silico_growth_curve.csv');

time = data_table.times;
cells = data_table.cells;

%% plot data

figure(1)
plot(time, cells, 'bo','MarkerSize',8,'LineStyle','none','MarkerFaceColor','b','MarkerEdgeColor','k');
xlabel('Time');
ylabel('Cells');
set(gca,'YScale','log');
set(gca,'Fontsize',20);
set(gca,'fontname','times');



%% flags and settings

flags.logtransformed = 1;
flags.logNormal = 1;

theta_guess = [0.6, 0.09, -9.1739 , 2.7782];
error_initial = ssfun(theta_guess,data_table,flags);



%% best fit parameter  -- mcmc

addpath(genpath('./../mcmcstat'));

model.ssfun = @(theta,data_for_mcmc) ssfun_mcmc(theta,data_for_mcmc,flags);

model.S20 = 1;
model.N0  = 1;

options.nsimu = 5000;
options.updatesigma = 1;
options.method   = 'dram';

data_for_mcmc.xdata = time;
data_for_mcmc.ydata = cells;




log_sigma_Qn = 0.5*(log(6.7e-10 + 6.7e-11)/log(10) - log(6.7e-10 - 6.7e-11)/log(10));


params = {
% initial values for the model states
    {'mu_max ', 0.6, 0, 10, 0.6, 0.06 }
    {'Ks', 0.09,  0, 1, 0.09,  0.081 }
    {'log_Qn', -9.1739,   -15, -6, -9.1739,   log_sigma_Qn }
    {'log_N0', 2.7782,   0, 10, 2.7782,   1}
    };


[results, chain, s2chain] = mcmcrun(model,data_for_mcmc,params,options);

%% saving file


id = 2;
filename = "logtransformed_" + string(flags.logtransformed) + "_logNormal_" + string(flags.logNormal)+"_id_"+string(id);

path = "./../results/";
save(path + filename);


%% plotting and saving figure

addpath('./../tools/');

% Time span
tspan_finer = 0:0.1:13.5;

%without the non-negative this problem will lead to an infeasible solution.
opts = odeset('RelTol',1e-2,'AbsTol',1e-5,'NonNegative',1);

transparency = 0.1;
linewidth = 2;

figure(2)
plot(time, cells, 'ko','MarkerSize',8,'LineStyle','none','MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
set(gca,'YScale','log');


for i = 2500:10:5000

i

theta = chain(i,:);
% Parameters
mu_max = theta(1);
Ks = theta(2);

if flags.logNormal == 1
Qn = 10.^theta(3);
N0 = 10.^theta(4);
else
Qn = theta(3);
N0 = theta(4);  
end


% Initial conditions
y0 = [N0, cells(1)];


% Solve the ODE
[t, y] = ode45(@(t, y) growth_ode(t, y, mu_max, Ks, Qn), tspan_finer, y0,opts);


figure(2)
patchline(t,y(:,2),'edgecolor',[0 0 1],'edgealpha',transparency,'LineWidth',linewidth)

end


xlabel('Time');
ylabel('Cells');

set(gca,'Fontsize',20);
set(gca,'fontname','times');