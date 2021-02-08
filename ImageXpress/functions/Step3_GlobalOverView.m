addpath('Functions/');

clc; clear;
% Name = '20190711_6'
Name = 'Data1_control';
%  Name = 'Data2_control';
% % Name = 'Data3_resting';
% % Name = 'Data4_resting';
% 
load(['Data/' Name '.mat']);
%% 1. Division Period

LifeSpan = [ Division_Events.LifeSpan ];
LifeSpan = LifeSpan(LifeSpan~=0);

figure;set(gcf,'position',[700 ,50,340,300]);
[Y X] = hist(LifeSpan,10);
superbar(X, Y ,'BarFaceColor', [0 0 0]);
set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45)
title('Doubling Period')


%% 2. Mother Size
Size_divd = [Division_Events.Size_divd];
Size_divd = Size_divd(Size_divd~=0);

figure;set(gcf,'position',[700 ,50,340,300]);
[Y X] = hist(Size_divd,10);
superbar(X, Y ,'BarFaceColor', [0 0 0]);
set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45)
title('Size Before Division')

%% 3. Daughter Size
Size_born = [Division_Events.Size_born];
Size_born = Size_born(Size_born~=0);

figure;set(gcf,'position',[700 ,50,340,300]);
[Y X] = hist(Size_born,10);
superbar(X, Y ,'BarFaceColor', [0 0 0]);
set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45)
title('Size Birth')
%%


colors = lines(length(Division_Events));
figure; hold on; set(gcf,'position',[500 500 400 300]); subplot(1,1,1); hold on; xlim([10 70]); ylim([0 180]);

break_up = 0;
for i=1:length(Division_Events)
    t       = Division_Events(i).t;
    cell_i  = Division_Events(i).sister(1);
    Sister_Pair = Yeastbow_Get_sisters(Fission,t,cell_i);  
    if(mean([Sister_Pair.angle])<90)
        break_up = break_up+1;
            plot(mean([Sister_Pair.dist]),mean([Sister_Pair.angle]),'+','markersize',13,'linewidth',2,'color',colors(i,:));
    end
    plot([Sister_Pair.dist],[Sister_Pair.angle],'.','markersize',5,'color',[.8 .8 .8]);
    plot(mean([Sister_Pair.dist]),mean([Sister_Pair.angle]),'.','markersize',15,'color',colors(i,:));

    ylabel('Daughter Angle');
    xlabel('Daughter Distance');
    % scatter([Sister_Pair.dist],[Sister_Pair.angle],[1:length(Sister_Pair)],'filled'
end

Frequency = round(100*(break_up/length(Division_Events)))/100;
title(['break up ratio = '  num2str(Frequency)]);



%%

figure; hold on; set(gcf,'color','w','position',[50 500 400*3 300]);  hold on;

subplot(1,3,1); hold on;

for i=1:length(Division_Events)
  plot(Division_Events(i).area1,'markersize',20);
  plot(Division_Events(i).area2,'markersize',20);
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Area');

subplot(1,3,2); hold on;

for i=1:length(Division_Events)
    if length(Division_Events(i).area1)>1
  plot(Division_Events(i).area1/(Division_Events(i).area1(1)),'markersize',20);
    end
    if length(Division_Events(i).area2)>1
  plot(Division_Events(i).area2/(Division_Events(i).area2(1)),'markersize',20);
    end
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Area (Normalized)');



subplot(1,3,3); hold on;
for i=1:length(Division_Events)
  x = Division_Events(i).area1;
  y = Division_Events(i).area2;
  I = min([length(x) length(y)]);
  plot(x(1:I),y(1:I),'.','markersize',10);
end
xLimits = min([get(gca,'XLim'); get(gca,'YLim')]);
yLimits = max([get(gca,'XLim'); get(gca,'YLim')]);
plot([xLimits(1) yLimits(2)],[xLimits(1) yLimits(2)],'k:','markersize',10);
xlim([xLimits(1) yLimits(2)]);
ylim([xLimits(1) yLimits(2)]);


set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Area (sister 1)');
ylabel('Area (sister 2)');


%%  Fig show sister length

figure; hold on; set(gcf,'color','w','position',[50 500 400*3 300]);  hold on;

subplot(1,3,1); hold on;

for i=1:length(Division_Events)
  plot(Division_Events(i).length1,'markersize',20);
  plot(Division_Events(i).length2,'markersize',20);
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Length');

subplot(1,3,2); hold on;

for i=1:length(Division_Events)
    if length(Division_Events(i).area1)>1
  plot(Division_Events(i).length1/(Division_Events(i).length1(1)),'markersize',20);
    end
    if length(Division_Events(i).area2)>1
  plot(Division_Events(i).length2/(Division_Events(i).length2(1)),'markersize',20);
    end
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Length (Normalized)');



subplot(1,3,3); hold on;
for i=1:length(Division_Events)
  x = Division_Events(i).length1;
  y = Division_Events(i).length2;
  I = min([length(x) length(y)]);
  plot(x(1:I),y(1:I),'.','markersize',10);
end
xLimits = min([get(gca,'XLim'); get(gca,'YLim')]);
yLimits = max([get(gca,'XLim'); get(gca,'YLim')]);
plot([xLimits(1) yLimits(2)],[xLimits(1) yLimits(2)],'k:','markersize',10);
xlim([xLimits(1) yLimits(2)]);
ylim([xLimits(1) yLimits(2)]);

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Length (sister 1)');
ylabel('Length (sister 2)');


%%  Fig show sister width


figure; hold on; set(gcf,'color','w','position',[50 500 400*3 300]);  hold on;

subplot(1,3,1); hold on;

for i=1:length(Division_Events)
  plot(Division_Events(i).width1,'markersize',20);
  plot(Division_Events(i).width2,'markersize',20);
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Width');

subplot(1,3,2); hold on;

for i=1:length(Division_Events)
    if length(Division_Events(i).area1)>1
  plot(Division_Events(i).width1/(Division_Events(i).width1(1)),'markersize',20);
    end
    if length(Division_Events(i).area2)>1
  plot(Division_Events(i).width2/(Division_Events(i).width2(1)),'markersize',20);
    end
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Width (Normalized)');



subplot(1,3,3); hold on;
for i=1:length(Division_Events)
  x = Division_Events(i).width1;
  y = Division_Events(i).width2;
  I = min([length(x) length(y)]);
  plot(x(1:I),y(1:I),'.','markersize',10);
end
xLimits = min([get(gca,'XLim'); get(gca,'YLim')]);
yLimits = max([get(gca,'XLim'); get(gca,'YLim')]);
plot([xLimits(1) yLimits(2)],[xLimits(1) yLimits(2)],'k:','markersize',10);
xlim([xLimits(1) yLimits(2)]);
ylim([xLimits(1) yLimits(2)]);

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Width (sister 1)');
ylabel('Width (sister 2)');

%%

%%

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);

