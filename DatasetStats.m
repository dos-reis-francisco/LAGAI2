%% Load the dataset and plot the distributions of the properties
clc; clear all; close all;
Data=importdata('Dataset_45K_FDR.csv');

Normalizer=210000;

Data(:,1:3)=Data(:,1:3)/Normalizer;


h1=histogram(Data(:,1),10,'Normalization','pdf')
hold on
h2=histogram(Data(:,2),10,'Normalization','pdf')
hold on
h3=histogram(Data(:,3),10,'Normalization','pdf')
%xlim([0.02 0])
xlabel('Normalized Modulus (-)')
ylabel('Probability Density (-)')
set(h1,'FaceColor',[0.47 0.67 0.19],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
set(h2,'FaceColor',[0.93 0.69 0.13],'EdgeColor',[0.93 0.69 0.13],'facealpha',0.5, 'EdgeAlpha', 0.5);
set(h3,'FaceColor',[0.07 0.61 1],'EdgeColor',[0.07 0.61 1],'facealpha',0.5, 'EdgeAlpha', 0.5);
legend('E_x^*','E_y^*', 'G_{xy}^*')

a=findobj(gcf); % get the handles associated with the current figure
%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

%% Figure 2
figure(2)
h4=histogram(Data(:,4),12,'Normalization','pdf')
set(h4,'FaceColor',[0.85 0.33 0.10],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
xlabel('Poisson ratio (-)')
ylabel('Probability Density (-)')
a=findobj(gcf); % get the handles associated with the current figure
%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

%% Figure 3
figure(3)
h5=histogram(Data(:,5),8,'Normalization','pdf')
set(h5,'FaceColor',[0.47 0.67 0.19],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
xlim([0.02 0.24])
xlabel('Relative Density \rho (-)')
ylabel('Probability Density (-)')
a=findobj(gcf); % get the handles associated with the current figure
%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

%% plot 3D scatter
figure(3)
scatter3(Data(:,1),Data(:,2),Data(:,3),2,Data(:,3))
xlabel('E_x^*')
ylabel('E_y^*')
zlabel('G_{xy}^*')
view([141 45])
a=findobj(gcf); % get the handles associated with the current figure
%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

%% plot 2D scatter
figure(3)
scatter(Data(:,1),Data(:,2),2,Data(:,2))
grid on
%xlabel('E_x^*')
%ylabel('G_{xy}^*')
%zlabel('G_{xy}^*')
%view([141 45])
a=findobj(gcf); % get the handles associated with the current figure
%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',2.5,'FontSize',42);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',2.5,'FontSize',42)
