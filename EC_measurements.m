
% NB: folder with data will likely need to be renamed if using own data
data = xlsread('/Users/Rocky/Desktop/Egg_Chamber_Scaling_Development/EC_Measurements_Cleaned.xlsx');

num_chamber = size(data,1)./16;

eggvol = zeros(1,num_chamber);
nucvol = zeros(1,num_chamber);
nuclvol = zeros(1,num_chamber);
oocytevol = zeros(1,num_chamber);

for i = 1:length(eggvol)
    eggvol(i) = sum(data(16*i-15:16*i,3));
    nucvol(i) = sum(data(16*i-15:16*i,5));
    nuclvol(i) = sum(data(16*i-15:16*i,6));
    oocytevol(i) = data(16*i-15,3);
end

X = repmat(eggvol,16,1);
Y = repmat(oocytevol,16,1);
Z = repmat([0 4 3 3 2 2 2 2 1 1 1 1 1 1 1 1],num_chamber,1)';
data(:,end+1) = X(:);
data(:,end+1) = Y(:);
data(:,end+1) = Z(:);

data1 = data(data(:,2) == 1,:);
data2 = data(data(:,2) == 2,:);
data3 = data(data(:,2) == 3,:);
data4 = data(data(:,2) == 4,:);
data5 = data(data(:,2) == 5,:);

datanc = [data2; data3; data4; data5];
%%
small_egg_fit_log = fitlm(log10(eggvol(eggvol < 1e5)),log10(oocytevol(eggvol < 1e5)));
big_egg_fit_log = fitlm(log10(eggvol(eggvol > 1e5)),log10(oocytevol(eggvol > 1e5)));

small_nurse_fit_log = fitlm(log10(eggvol(eggvol < 1e5)),log10(eggvol(eggvol < 1e5)-oocytevol(eggvol < 1e5)));
big_nurse_fit_log = fitlm(log10(eggvol(eggvol > 1e5)),log10(eggvol(eggvol > 1e5)-oocytevol(eggvol > 1e5)));

total_nurse_fit = fitlm(log10(eggvol),log10(eggvol-oocytevol));

x1 = linspace(min(eggvol(eggvol < 1e5)),1e5,100);
x2 = linspace(1e5,max(eggvol(eggvol > 1e5)),100);

y_small_egg = 10.^(table2array(small_egg_fit_log.Coefficients(2,1)).*log10(x1) + table2array(small_egg_fit_log.Coefficients(1,1)));
y_big_egg = 10.^(table2array(big_egg_fit_log.Coefficients(2,1)).*log10(x2) + table2array(big_egg_fit_log.Coefficients(1,1)));
y_small_nurse = 10.^(table2array(small_nurse_fit_log.Coefficients(2,1)).*log10(x1) + table2array(small_nurse_fit_log.Coefficients(1,1)));
y_big_nurse = 10.^(table2array(big_nurse_fit_log.Coefficients(2,1)).*log10(x2) + table2array(big_nurse_fit_log.Coefficients(1,1)));

figure;
loglog(eggvol,oocytevol,'ko','MarkerSize',12); hold on
loglog(eggvol,eggvol-oocytevol,'kd','MarkerSize',12); hold on
plot(x1,y_small_egg,':','Color',[1 0.5 0],'LineWidth',3)
plot(x2,y_big_egg,'-','Color',[1 0.5 0],'LineWidth',3)
plot(x1,y_small_nurse,':','Color',[0.25 0.25 0.25],'LineWidth',3)
plot(x2,y_big_nurse,'-','Color',[0.25 0.25 0.25],'LineWidth',3)
xlabel('Egg chamber volume (\mum^3)')
ylabel('Volume (\mum^3)')
axis([1e4 1e6 1e2 1e6])
box on; grid off; axis square
legend('Oocyte','Nurse Cells','location','northwest','FontSize',16)
ax = gca;
ax.FontSize = 20;
%% total nurse cell vol frac vs. total EC volume
figure;
semilogx(data2(:,12),data2(:,10),'o','Color',[92/255 157/255 178/255],'LineWidth',0.5,'MarkerFaceColor',[92/255 157/255 178/255],'MarkerSize',10); hold on
plot(data3(:,12),data3(:,10),'o','Color',[180/255 67/255 59/255],'LineWidth',0.5,'MarkerFaceColor',[180/255 67/255 59/255],'MarkerSize',10);
plot(data4(:,12),data4(:,10),'o','Color',[45/255 99/255 68/255],'LineWidth',0.5,'MarkerFaceColor',[45/255 99/255 68/255],'MarkerSize',10);
plot(data5(:,12),data5(:,10),'o','Color',[251/255 192/255 52/255],'LineWidth',0.5,'MarkerFaceColor',[251/255 192/255 52/255],'MarkerSize',10);
xlabel('Egg chamber volume (\mum^3)','FontSize',24)
ylabel('Total nurse cell volume fraction','FontSize',24)
ax = gca;
ax.FontSize = 20;
box on; grid off; axis square
axis([10^4 10^6 0 0.16])
%% EC cell vol frac vs. total EC volume
figure;
semilogx(data2(:,12),data2(:,4),'o','Color',[92/255 157/255 178/255],'LineWidth',0.5,'MarkerFaceColor',[92/255 157/255 178/255],'MarkerSize',10); hold on
plot(data3(:,12),data3(:,4),'o','Color',[180/255 67/255 59/255],'LineWidth',0.5,'MarkerFaceColor',[180/255 67/255 59/255],'MarkerSize',10);
plot(data4(:,12),data4(:,4),'o','Color',[45/255 99/255 68/255],'LineWidth',0.5,'MarkerFaceColor',[45/255 99/255 68/255],'MarkerSize',10);
plot(data5(:,12),data5(:,4),'o','Color',[251/255 192/255 52/255],'LineWidth',0.5,'MarkerFaceColor',[251/255 192/255 52/255],'MarkerSize',10);
plot(data1(:,12),data1(:,4),'o','Color',[204/255 204/255 204/255],'LineWidth',0.5,'MarkerFaceColor',[204/255 204/255 204/255],'MarkerSize',12);
xlabel('Egg chamber volume (\mum^3)')
ylabel('Volume fraction')
ax = gca;
ax.FontSize = 20;
box on; grid off; axis square
axis([10^4 10^6 0 0.35])
%% get volume rankings plot
volrank = zeros(2,15);
nucrank = zeros(2,15);
for i = 2:16
    volrank(1,i-1) = mean(data((data(:,1) == i),8));
    volrank(2,i-1) = std(data((data(:,1) == i),8))./sqrt(num_chamber);
    nucrank(1,i-1) = mean(data((data(:,1) == i),9));
    nucrank(2,i-1) = std(data((data(:,1) == i),9))./sqrt(num_chamber);
end

mdl_nuc_cell_fit = fitlm(volrank(1,:),nucrank(1,:),'intercept',false);

figure;
errorbar(volrank(1,[1,2,4,8]),nucrank(1,[1,2,4,8]),nucrank(2,[1,2,4,8]),nucrank(2,[1,2,4,8]),volrank(2,[1,2,4,8]),volrank(2,[1,2,4,8]),'d','Color',[92/255 157/255 178/255],'LineWidth',2,'MarkerFaceColor',[92/255 157/255 178/255],'MarkerSize',8); hold on
errorbar(volrank(1,[3,5,6,9,10,12]),nucrank(1,[3,5,6,9,10,12]),nucrank(2,[3,5,6,9,10,12]),nucrank(2,[3,5,6,9,10,12]),volrank(2,[3,5,6,9,10,12]),volrank(2,[3,5,6,9,10,12]),'d','Color',[180/255 67/255 59/255],'LineWidth',2,'MarkerFaceColor',[180/255 67/255 59/255],'MarkerSize',8);
errorbar(volrank(1,[7,11,13,14]),nucrank(1,[7,11,13,14]),nucrank(2,[7,11,13,14]),nucrank(2,[7,11,13,14]),volrank(2,[7,11,13,14]),volrank(2,[7,11,13,14]),'d','Color',[45/255 99/255 68/255],'LineWidth',2,'MarkerFaceColor',[45/255 99/255 68/255],'MarkerSize',8);
errorbar(volrank(1,15),nucrank(1,15),nucrank(2,15),nucrank(2,15),volrank(2,15),volrank(2,15),'d','Color',[251/255 192/255 52/255],'LineWidth',2,'MarkerFaceColor',[251/255 192/255 52/255],'MarkerSize',8);
plot(1:16,1:16,'k--'); axis square; box on; grid off;
axis([1 15 1 15])
xlabel('Average cell volume rank')
ylabel('Average nuclear volume rank')
ax = gca;
ax.FontSize = 20;
%% total cell nuc vs. nucl

figure;
loglog(nucvol+nuclvol, nuclvol, 'kd','MarkerSize',16,'LineWidth',2); hold on

log_nuc_nucl = fitlm(log10(nucvol+nuclvol),log10(nuclvol));

total_nuc_nucl = fitlm(nucvol+nuclvol,nuclvol);
nuc_nucl_slope = table2array(log_nuc_nucl.Coefficients(2,1));
nuc_nucl_slope_std = table2array(log_nuc_nucl.Coefficients(2,2));
nuc_nucl_int = table2array(log_nuc_nucl.Coefficients(1,1));
nuc_nucl_int_std = table2array(log_nuc_nucl.Coefficients(1,2));

x = linspace(min((nucvol+nuclvol)),max((nucvol+nuclvol)),100);
plot(x,10.^(nuc_nucl_slope*log10(x)+nuc_nucl_int),'k-','LineWidth',3)
xlabel('Total nuclear volume (\mum^3)')
ylabel('Total nucleolar volume (\mum^3)')
box on; axis square;
% axis([5e3 1.5e5 9e2 3e4])
axis([2e3 2e5 5e2 5e4])
ax = gca;
ax.FontSize = 20;
%% nuclear and nucleolar vol. vs. cell vol.

fullnurse = [data2; data3; data4; data5];

mdl_nucleolus = fitlm(log10(fullnurse(:,3)),log10(fullnurse(:,6)));
mdl_envelope = fitlm(log10(fullnurse(:,3)),log10(fullnurse(:,7)));

linefit = linspace(min(fullnurse(:,3)), max(fullnurse(:,3)), 100);
y_nucleolus = 10.^(table2array(mdl_nucleolus.Coefficients(2,1)).*log10(linefit) + table2array(mdl_nucleolus.Coefficients(1,1)));
y_envelope = 10.^(table2array(mdl_envelope.Coefficients(2,1)).*log10(linefit) + table2array(mdl_envelope.Coefficients(1,1)));

% nuc vol, cell vol
figure;
loglog(data2(:,3),data2(:,7),'s','Color',[0.49 0.18 0.56],'LineWidth',1.25,'MarkerSize',10)
hold on
plot(data2(:,3),data2(:,6),'r+','LineWidth',1.25,'MarkerSize',10)
plot(data3(:,3),data3(:,7),'s','Color',[0.49 0.18 0.56],'LineWidth',1.25,'MarkerSize',10)
plot(data4(:,3),data4(:,7),'s','Color',[0.49 0.18 0.56],'LineWidth',1.25,'MarkerSize',10)
plot(data5(:,3),data5(:,7),'s','Color',[0.49 0.18 0.56],'LineWidth',1.25,'MarkerSize',10)
plot(linefit,y_envelope,'k-','LineWidth',3)
plot(data3(:,3),data3(:,6),'r+','LineWidth',1.25,'MarkerSize',10)
plot(data4(:,3),data4(:,6),'r+','LineWidth',1.25,'MarkerSize',10)
plot(data5(:,3),data5(:,6),'r+','LineWidth',1.25,'MarkerSize',10)
plot(linefit,y_nucleolus,'k--','LineWidth',3)
xlabel('Cell Volume (\mum^3)')
ylabel('Organelle Volume (\mum^3)')
legend('Nucleus', 'Nucleolus','location','northwest','FontSize',16)
axis([5e2 1e5 1e1 2e4]); box on; axis square
ax = gca;
ax.FontSize = 20;