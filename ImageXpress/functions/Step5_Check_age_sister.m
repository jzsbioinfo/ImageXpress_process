
clc; clear; close all;
addpath('Functions/');

% Name = '20190711_6';
Name = 'Data1_control';
%  Name = 'Data2_control';
% Name = 'Data3_resting';
% % Name = 'Data4_resting';
%
load(['Data/' Name '.mat']);

%%  Fig show sister area
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


%% Tree_age v.s. Width



figure; hold on; set(gcf,'color','w','position',[50 500 400*2 300]);  hold on;

subplot(1,2,1); hold on;

for i=1:length(Division_Events)
  if length(Division_Events(i).area1)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).width1(1),'.','markersize',20);
  end
  if length(Division_Events(i).area2)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).width2(1),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Width(initial)');


subplot(1,2,2); hold on;

for i=1:length(Division_Events)
  if length(Division_Events(i).area1)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).width1(end),'.','markersize',20);
  end
  if length(Division_Events(i).area2)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).width2(end),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Width(end)');

%% Tree_age v.s. Length


figure; hold on; set(gcf,'color','w','position',[50 500 400*2 300]);  hold on;

subplot(1,2,1); hold on;

for i=1:length(Division_Events)
  if length(Division_Events(i).area1)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).length1(1),'.','markersize',20);
  end
  if length(Division_Events(i).area2)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).length2(1),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Length(initial)');


subplot(1,2,2); hold on;

for i=1:length(Division_Events)
  if length(Division_Events(i).area1)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).length1(end),'.','markersize',20);
  end
  if length(Division_Events(i).area2)>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).length2(end),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Length(end)');


%% Tree_age v.s. Area

figure; hold on; set(gcf,'color','w','position',[50 500 400*2 300]);  hold on;

subplot(1,2,1); hold on;

for i=1:length(Division_Events)
  if (Division_Events(i).LifeSpan(1))>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).area1(1),'.','markersize',20);
  end
  if (Division_Events(i).LifeSpan(2))>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).area2(1),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Area(initial)');


subplot(1,2,2); hold on;

for i=1:length(Division_Events)
  if (Division_Events(i).LifeSpan(1))>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).area1(end),'.','markersize',20);
  end
  if (Division_Events(i).LifeSpan(2))>1
  plot(Division_Events(i).Tree_age(1),Division_Events(i).area2(end),'.','markersize',20);
  end

end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('Generation');
ylabel('Area(end)');



%% Lineage Tree
figure; hold on; set(gcf,'color','w','position',[500 500 400*2 300*2]);  hold on;
nodes = [Division_Events.Tree];
[x,y] = treelayout(nodes);
treeplot(nodes,'blacko', 'black');
offset = 0.01;
for i=1:length(x)
    if Division_Events(i).type
        plot(x(i),y(i),'r.','markersize',20);
    else
        plot(x(i),y(i),'k.','markersize',20);
    end
%     text(x(i) + offset,y(i),num2str([Division_Events(i).t])); % show time
%     text(x(i) + offset,y(i),num2str(i)); % show ID
end

set(gca,'Linewidth',3,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);axis off;
