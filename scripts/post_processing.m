clear all;
clc;

%% load data

load('./../results/logtransformed_1_logNormal_1_id_2.mat')

%% traceplots

burn = 3000;
chain_store = chain;
clear chain;

chain = chain_store(burn:end,:);


figure

subplot(5,2,1)
histogram(chain(1:end/2,1),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','b','LineWidth',2);
hold on;
histogram(chain(end/2+1:end,1),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','r','LineWidth',2);


xlabel('\mu max');
ylabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);

subplot(5,2,2)
plot(chain(1:end/2,1),'Color','b','LineWidth',2);
hold on;
plot(chain(end/2+1:end,1),'Color','r','LineWidth',2);
ylabel('\mu max');
xlabel('trace');
set(gca,'fontname','times');
set(gca,'Fontsize',20);



subplot(5,2,3)
histogram(chain(1:end/2,2),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','b','LineWidth',2);
hold on;
histogram(chain(end/2+1:end,2),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','r','LineWidth',2);
xlabel('K_s');
ylabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);

subplot(5,2,4)
plot(chain(1:end/2,2),'Color','b','LineWidth',2);
hold on;
plot(chain(end/2+1:end,2),'Color','r','LineWidth',2);
ylabel('K_s');
xlabel('trace');
set(gca,'fontname','times');
set(gca,'Fontsize',20);



subplot(5,2,5)
histogram(10.^chain(1:end/2,3),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','b','LineWidth',2);
hold on;
histogram(10.^chain(end/2+1:end,3),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','r','LineWidth',2);
xlabel('Q_n');
ylabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);


subplot(5,2,6)
plot(10.^chain(1:end/2,3),'Color','b','LineWidth',2);
hold on;
plot(10.^chain(end/2+1:end,3),'Color','r','LineWidth',2);
ylabel('Q_n');
xlabel('trace');
set(gca,'fontname','times');
set(gca,'Fontsize',20);

subplot(5,2,7)
histogram(10.^chain(1:end/2,4),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','b','LineWidth',2);
hold on;
histogram(10.^chain(end/2+1:end,4),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','r','LineWidth',2);
xlabel('N0');
ylabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);

subplot(5,2,8)
plot(10.^chain(1:end/2,4),'Color','b','LineWidth',2);
hold on;
plot(10.^chain(end/2+1:end,4),'Color','r','LineWidth',2);
ylabel('N_0');
xlabel('trace');
set(gca,'fontname','times');
set(gca,'Fontsize',20);


subplot(5,2,9)
histogram(s2chain(1:end),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','b','LineWidth',2);
hold on;
histogram(s2chain(end/2+1:end,1),'DisplayStyle','stairs','Normalization','pdf','EdgeColor','r','LineWidth',2);
xlabel('\sigma_{LL}');
ylabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);



subplot(5,2,10)
plot(s2chain(burn:4000),'Color','b','LineWidth',2);
hold on
plot(s2chain(4000:end),'Color','r','LineWidth',2);
ylabel('\sigma_{LL}');
xlabel('PDF');
set(gca,'fontname','times');
set(gca,'Fontsize',20);



%% covariaance

chain(:,5) = s2chain(3000:end);
count = 1;

ax_list = {'\mu_{max}', 'K_s', 'log(Q_s)', 'log(N_0)', 'sigma^2'};

figure;
for i = 1:5
    for j = 1:5
        subplot(5, 5, count);
        if i ~= j
            plot(chain(:, j), chain(:, i), 'b.');
            xlabel(ax_list{j}, 'Interpreter', 'tex');
            ylabel(ax_list{i}, 'Interpreter', 'tex');
        else
            smoothHistogram(chain(:, i), 10, [0 0 0]);
            xlabel(ax_list{i}, 'Interpreter', 'tex');
            ylabel('PDF', 'Interpreter', 'tex');
        end
        count = count + 1;
    end
end


%% test for convergence

%%% geweke

 chainstats(chain_store);


% GR.

chain_1 = chain(1:1000,:);
chain_2 = chain(1001:2000,:);

mean_chain_1  = mean(chain_1);
mean_chain_2  = mean(chain_2);
grand_mean = 0.5*(mean_chain_1 + mean_chain_2);

N = length(chain_1);
M = 2;

B = N/(M-1) * ((mean_chain_1 - grand_mean).^2 + (mean_chain_2 - grand_mean).^2 ) ;

v_1 = (std(chain_1)).^2 ;
v_2 = (std(chain_2)).^2 ;

W = (1/M) * (v_1 + v_2) ;


R =  ( (N-1)/N * W + (B/N) ) ./W
