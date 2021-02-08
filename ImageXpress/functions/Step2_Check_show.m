addpath('Functions/');


clc; clear;

Name = '20190711_6'

% Name = 'Data1_control';
% Name = 'Data2_control';
% Name = 'Data3_resting';
% Name = 'Data4_resting';


load(['Data/' Name '.mat']);

close all; figure;  set(gcf,'position',[100 200 800 800]); hold on;xlim([0 512]);ylim([0 512]); axis off;

for t = 2:length(Fission)
    cla; imagesc(Fission(t).BW);

    for cell_i = 1:length(Fission(t).centroid)

        Cell_xy   = Fission(t).centroid(cell_i).Centroid;
        Cell_ROI  = Fission(t).ROIs(cell_i).ConvexHull;
        Cell_k    = Fission(t).k(cell_i).k;
        heads_age = Fission(t).Heads(cell_i).age;
        ends_age  = Fission(t).Ends(cell_i).age;

        daughter_head = Fission(t).Heads(cell_i).Heads;
        daughter_end  = Fission(t).Ends(cell_i).Ends;
        daughter_up   = Fission(t).Up(cell_i).Up;
        daughter_down = Fission(t).Down(cell_i).Down;     
        
        plot(Cell_ROI(:,1),Cell_ROI(:,2),'w.','markersize',5);
        plot(Cell_xy(1),Cell_xy(2),'r.','markersize',20);
        plot(daughter_head(1),daughter_head(2),'g.','markersize',20+(heads_age*5));
        plot(daughter_end(1),daughter_end(2),'m.','markersize',20+(heads_age*5));
        text(daughter_head(1),daughter_head(2),num2str(heads_age));
        text(daughter_end(1),daughter_end(2),num2str(ends_age));
        plot(daughter_up(1),daughter_up(2),'k.','markersize',20);
        plot(daughter_down(1),daughter_down(2),'k.','markersize',20);
       
    end
Gif(['Gifs/' Name '.gif'],t-1);
end
