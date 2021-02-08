

i=10;
    t       = Division_Events(i).t;
    cell_i  = Division_Events(i).sister(1);
    Sister_Pair = Yeastbow_Get_sisters(Fission,t,cell_i);  


%%
close all;
figure; hold on;
set(gcf,'position',[200 300 500 300]);
plot([Sister_Pair.dist],[Sister_Pair.angle],'r.','markersize',20)
scatter([Sister_Pair.dist],[Sister_Pair.angle],[1:length(Sister_Pair)],'filled')


%%
close all;
figure; 
set(gcf,'position',[100 200 800 800]);
hold on;xlim([0 512]);ylim([0 512]);
axis off;
T     = [Sister_Pair.t];
Cells = [Sister_Pair.index]';



for i = 1:length(Sister_Pair)
    t = T(i);
    cla;
      imagesc(Fission(t).BW);
      title(['angle = ' num2str(Sister_Pair(i).angle)]);
% Sister_Pair(i).dist;
% Sister_Pair(i).angle;
    for cell_i = Cells(i,:)
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
%     pause(.1);
    Gif(['sister.avi'],i);

end


%%









