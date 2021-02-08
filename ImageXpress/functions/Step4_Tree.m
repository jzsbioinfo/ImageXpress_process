
clc; clear;
addpath('Functions/');

% Name = '20190711_6'
Name = 'Data1_control';
%  Name = 'Data2_control';
% Name = 'Data3_resting';
% Name = 'Data4_resting';
%
load(['Data/' Name '.mat']);

%%
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

