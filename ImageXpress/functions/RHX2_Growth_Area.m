function RHX2_Growth_Area(Lineages,Budding)
   
T = length(Lineages.Lineage_index);

%% ============== 1 . ROIs
set(gcf,'color','w','position',[100 200 800 400]);

subplot(1,2,1); hold on;

for t = length(Lineages.Lineage_index):-1:1
    cell_i = Lineages.Lineage_index(t);
    if cell_i ~=0
    Cell_ROI  = Budding(t).ROIs(cell_i).ConvexHull;
    patch( Cell_ROI(:,1),  Cell_ROI(:,2), t ,'facealpha',.8); % use color i.
    end
    %         patch( vorono.c{i}(:,1),    vorono.c{i}(:,2),'w','edgecolor',Colors_16(j,:)); % use color i.
end

axis image;
axis off;

[map,num,typ] = brewermap(100,'RdBu'); % GnBu
map=map(end:-1:1,:);
colormap(map);


%% ============== 2 . area curves 

subplot(1,2,2); hold on;


for i= 1:length(Budding(T).centroid)
    Lineagess_temp = Lineage(Budding,T,i);
area1 = Get_Properities(1:length(Lineagess_temp.Lineage_index),Lineagess_temp.Lineage_index,'area',Budding);
plot(area1(1:end-1),':','color',[.5 .5 .5],'Linewidth',1)
end


area1 = Get_Properities(1:length(Lineages.Lineage_index),Lineages.Lineage_index,'area',Budding);
scatter(1:length(Lineages.Lineage_index),area1,50,1:length(Lineages.Lineage_index),'filled','markeredgecolor',[.5 .5 .5]);
xlabel('time');
ylabel('area');
set(gca,'yscale','log');
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);


%% ==============
 

end