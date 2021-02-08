
addpath('Functions/');

%%

% Name = 'Data1_control';
% Name = 'Data2_control';
% Name = 'Data3_resting';
% Name = 'Data4_resting';

load(['Data/' Name '.mat']);

% close all;
colors = lines(length(Division_Events));
figure(1); hold on; set(gcf,'position',[50 50 1200 900]); subplot(2,2,1); hold on; xlim([10 70]); ylim([0 180]);

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
