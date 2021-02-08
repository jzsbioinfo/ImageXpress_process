% addpath('Functions/');
% 
% 
% clc; clear;
% 
% Name = '20190711_6'
% 
% % Name = 'Data1_control';
% % Name = 'Data2_control';
% % Name = 'Data3_resting';
% % Name = 'Data4_resting';
% 
% 
% load(['Data/' Name '.mat']);

close all; figure;  set(gcf,'color','w','position',[100 200 800 800]); hold on;axis off;
xlim([0 3000]);ylim([0 3000]);


for t = 2:length(Budding)
    cla; 

    for cell_i = 1:length(Budding(t).centroid)

        Cell_xy   = Budding(t).centroid(cell_i).Centroid;
        Cell_ROI  = Budding(t).ROIs(cell_i).ConvexHull;

        plot(Cell_ROI(:,1),Cell_ROI(:,2),'k-','markersize',5);
        plot(Cell_xy(1),Cell_xy(2),'r.','markersize',10);
        text(Cell_xy(1),Cell_xy(2),num2str(cell_i));
        title(['t = ' num2str(t) ' ( time point )']);
  
    end
    pause(.3);
% Gif(['Gifs/' Name '.gif'],t-1);
end

close;