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

