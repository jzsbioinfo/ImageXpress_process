function  RHX3_show_lineage(Budding,Lineages,Position,Name)

T = length(Lineages.Lineage_index);

if exist([Name '.gif'])
    delete([Name '.gif']);
end


%% ============== 1 . area curves 

subplot(1,2,2); hold on;

for i= 1:length(Budding(T).centroid)
    Lineagess_temp = Lineage(Budding,T,i);
area1 = Get_Properities(1:length(Lineagess_temp.Lineage_index),Lineagess_temp.Lineage_index,'area',Budding);
plot(area1(1:end-1),':','color',[.5 .5 .5],'Linewidth',2)

end

% speific cell area curve
area1 = Get_Properities(1:length(Lineages.Lineage_index),Lineages.Lineage_index,'area',Budding);
plot(1:length(Lineages.Lineage_index),area1,'k','Linewidth',3);
xlabel('time');
ylabel('area');
set(gca,'yscale','log');
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);

%% ==============
 


%% ============== 2 . area curves 

for t =  1:length(Lineages.Lineage_index)

 
subplot(1,2,1); hold on; cla; axis off;      
  
 for cell_i = 1:length(Budding(t).centroid)

        Cell_xy   = Budding(t).centroid(cell_i).Centroid;
        Cell_ROI  = Budding(t).ROIs(cell_i).ConvexHull;

        plot(Cell_ROI(:,1),Cell_ROI(:,2),'k-','markersize',5);
        plot(Cell_xy(1),Cell_xy(2),'b.','markersize',10);
%         text(Cell_xy(1),Cell_xy(2),num2str(cell_i));
        title(['t = ' num2str(t) ' ( time point )']);
  
 end
        
       
 
 
     cell_i = Lineages.Lineage_index(t);
if cell_i ~=0
    
        Cell_xy   = Budding(t).centroid(cell_i).Centroid;
        Cell_ROI  = Budding(t).ROIs(cell_i).ConvexHull;
   
 subplot(1,2,1); hold on; axis off;     %  axis image;
        patch( Cell_ROI(:,1),  Cell_ROI(:,2), 'r' ,'facealpha',1); % use color i.
%         plot(Cell_xy(1),Cell_xy(2),'r.','markersize',10);
%         text(Cell_xy(1),Cell_xy(2),num2str(cell_i));  
        xlim(Position.xlim);ylim(Position.ylim);
 subplot(1,2,2); hold on;
        plot(t,area1(t),'r.','markersize',20);

end
 
%     pause(.3);

 Gif([ Name '.gif'],t);

end


for i=1:10
     Gif([ Name '.gif'],t+i);
end

pause(3);
close;


%%


% 
% close all; figure;  set(gcf,'color','w','position',[100 200 800 800]); hold on;axis off;
% xlim([0 3000]);ylim([0 3000]);
% 
% 
% for t = 2:length(Budding)
%     cla; 
% 
%     for cell_i = 1:length(Budding(t).centroid)
% 
%         Cell_xy   = Budding(t).centroid(cell_i).Centroid;
%         Cell_ROI  = Budding(t).ROIs(cell_i).ConvexHull;
% 
%         plot(Cell_ROI(:,1),Cell_ROI(:,2),'k-','markersize',5);
%         plot(Cell_xy(1),Cell_xy(2),'r.','markersize',10);
%         text(Cell_xy(1),Cell_xy(2),num2str(cell_i));
%         title(['t = ' num2str(t) ' ( time point )']);
%   
%     end
%     pause(.3);
% % Gif(['Gifs/' Name '.gif'],t-1);
% end
