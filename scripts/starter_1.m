clear all;
clc;


%% load data

addpath(genpath("./../"))

data_table = readtable('./../data/in_silico_growth_curve.csv');

time = data_table.times;
cells = data_table.cells;

%% plot data

% plot(time, cells, 'bo','MarkerSize',8,'LineStyle','none','MarkerFaceColor','b','MarkerEdgeColor','k');
% xlabel('Time');
% ylabel('Cells');
% set(gca,'YScale','log');
% set(gca,'Fontsize',20);
% set(gca,'fontname','times');


%% initial model plot


% Parameters
mu_max = 0.6;
Ks = 0.09;
Qn = 6.7e-10;

% Initial conditions
y0 = [6e2, cells(1)];

% Time span
tspan = time;

%without the non-negative this problem will lead to an infeasible solution.
opts = odeset('RelTol',1e-2,'AbsTol',1e-5,'NonNegative',1);

% Solve the ODE
[t, y] = ode45(@(t, y) growth_ode(t, y, mu_max, Ks, Qn), tspan, y0,opts);



figure(2)
plot(time, cells, 'bo','MarkerSize',8,'LineStyle','none','MarkerFaceColor','b','MarkerEdgeColor','k');
hold on;
plot(t,y(:,2),'LineWidth',2,'Color','b')
xlabel('Time');
ylabel('Cells');
set(gca,'YScale','log');
set(gca,'Fontsize',20);
set(gca,'fontname','times');


% figure;
% subplot(2, 1, 1);
% plot(t, y(:,1));
% xlabel('Time');
% ylabel('N');


%% error initial

flags.logtransformed = 1;
theta_guess = [0.6, 0.09, 6.7e-8, 6e2];
error = ssfun(theta_guess,data_table,flags)



%% best fit parameter -- Least squares.




