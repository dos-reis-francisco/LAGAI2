%drawskin.m
function f=drawCloud2(Data,textX,textY,textZ,numfigure,AngleCamera)

%     [verts,faces,cindex]=convertObjMatlab(TPOINTS,TSEGMENTS,TFACES);
% 
%     f=figure; 
%     % ligne des X
%     line1=[-200;200];
%     line2=[0;0];
%     line3=[0;0];
%     % ligne des Y
%     line4=[0;0];
%     line5=[-200;200];
%     line6=[0;0];
%     % line des Z
%     line7=[0;0];
%     line8=[0;0];
%     line9=[-200;200];
%     hold all;
%     plot3(TNUAGE(:,1),TNUAGE(:,2),TNUAGE(:,3),'o','Color','g');
% 
%     % dessin des axes
%     plot3(line1,line2,line3,'-','Color','r');
%     plot3(line4,line5,line6,'-','Color','m');
%     plot3(line7,line8,line9,'-','Color','b');
%     text(200,0,0,'+'+textX,'Color','r');
%     text(-200,0,0,'-'+textX,'Color','r');
%     text(0,200,0,'+'+textY,'Color','m');
%     text(0,-200,0,'-'+textY,'Color','m');
%     text(0,0,200,'+'+textZ,'Color','b');
%     text(0,0,-200,'-'+textZ,'Color','b');
% 
%     % dessin des graduations sur les axes
%     for i=-1.5:0.75:1.5
%         val1=i*ecartType(1)+moyenne(1);
%         val1s=compose("%6.1f",val1);
%         text(i*100,0,0,val1s,'Color','r');
%         val2=i*ecartType(2)+moyenne(2);
%         val2s=compose("%6.1f",val2);
%         text(0,i*100,0,val2s,'Color','m');
%         val3=i*ecartType(3)+moyenne(3);
%         val3s=compose("%6.1f",val3);
%         text(0,0,i*100,val3s,'Color','b');
%     end 
%     p = patch('Faces',faces,'Vertices',verts,'FaceVertexCData',cindex,...
%     'FaceColor','interp','EdgeColor','none');
%     view(-151,30);     % change the orientation 
%     axis equal off    % make the axes equal and invisible
%     l = light('Position',[-0.4 0.2 0.9],'Style','infinite');
%     lighting gouraud;
%     rotate3d on;
%     alpha(0.5);

    %% partie Nikos
    %% Load the dataset and plot the distributions of the properties
% clc; clear all; close all;
% Data=importdata('Dataset_45K_FDR.csv');
% 
% Normalizer=210000;
% 
% Data(:,1:3)=Data(:,1:3)/Normalizer;


% h1=histogram(Data(:,1),10,'Normalization','pdf')
% hold on
% h2=histogram(Data(:,2),10,'Normalization','pdf')
% hold on
% h3=histogram(Data(:,3),10,'Normalization','pdf')
% %xlim([0.02 0])
% xlabel('Normalized Modulus (-)')
% ylabel('Probability Density (-)')
% set(h1,'FaceColor',[0.47 0.67 0.19],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
% set(h2,'FaceColor',[0.93 0.69 0.13],'EdgeColor',[0.93 0.69 0.13],'facealpha',0.5, 'EdgeAlpha', 0.5);
% set(h3,'FaceColor',[0.07 0.61 1],'EdgeColor',[0.07 0.61 1],'facealpha',0.5, 'EdgeAlpha', 0.5);
% legend('E_x^*','E_y^*', 'G_{xy}^*')

% a=findobj(gcf); % get the handles associated with the current figure
% %applyhatch(gcf,'|-+.\/')
% allaxes=findall(a,'Type','axes');
% alllines=findall(a,'Type','line');
% alltext=findall(a,'Type','text');
% set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
% %set(alllines,'LineWidth',2);
% set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

% %% Figure 2
% figure(2)
% h4=histogram(Data(:,4),12,'Normalization','pdf')
% set(h4,'FaceColor',[0.85 0.33 0.10],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
% xlabel('Poisson ratio (-)')
% ylabel('Probability Density (-)')
% a=findobj(gcf); % get the handles associated with the current figure
% %applyhatch(gcf,'|-+.\/')
% allaxes=findall(a,'Type','axes');
% alllines=findall(a,'Type','line');
% alltext=findall(a,'Type','text');
% set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
% %set(alllines,'LineWidth',2);
% set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

% %% Figure 3
% figure(3)
% h5=histogram(Data(:,5),8,'Normalization','pdf')
% set(h5,'FaceColor',[0.47 0.67 0.19],'EdgeColor',[0.47 0.67 0.19],'facealpha',0.5, 'EdgeAlpha', 0.5);
% xlim([0.02 0.24])
% xlabel('Relative Density \rho (-)')
% ylabel('Probability Density (-)')
% a=findobj(gcf); % get the handles associated with the current figure
% %applyhatch(gcf,'|-+.\/')
% allaxes=findall(a,'Type','axes');
% alllines=findall(a,'Type','line');
% alltext=findall(a,'Type','text');
% set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14);
% %set(alllines,'LineWidth',2);
% set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',14)

%% plot 3D scatter
f=figure(numfigure);

scatter3(Data(:,1),Data(:,2),Data(:,3),10,Data(:,3));
xlim([-300 300]);
ylim([-300 300]);
zlim([-300 300]);
xlabel(textX);
ylabel(textY);
zlabel(textZ);
view(AngleCamera);
a=findobj(gcf); % get the handles associated with the current figure

%applyhatch(gcf,'|-+.\/')
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',12);
%set(alllines,'LineWidth',2);
set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',1.5,'FontSize',12)

% %% plot 2D scatter
% figure(numfigure)
% scatter(Data(:,1),Data(:,2),2,Data(:,2))
% grid on
% xlabel(textX)
% ylabel(textY)
% zlabel(textZ)
% view([141 45])
% a=findobj(gcf); % get the handles associated with the current figure
% %applyhatch(gcf,'|-+.\/')
% allaxes=findall(a,'Type','axes');
% alllines=findall(a,'Type','line');
% alltext=findall(a,'Type','text');
% set(allaxes,'FontName','Times New Roman','FontWeight','n','LineWidth',2.5,'FontSize',42);
% %set(alllines,'LineWidth',2);
% set(alltext,'FontName','Times New Roman','FontWeight','n','LineWidth',2.5,'FontSize',42)

end