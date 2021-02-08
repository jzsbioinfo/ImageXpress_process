
function [ all_area ] = RHX1_Area_Curve(Budding,I)

if max(I)>length(Budding(end).area)
    I = 1:length(Budding(end).area);
end
hold on; set(gcf,'color','w','position',[50 500 400*2 300]);  hold on;



% for every cell cluster in the last segmentation figure
all_area = table()


n = 0
name = []
for i= I
    
    Lineages_temp = Lineage(Budding,length(Budding),i); % 使用lineage找到 cell cluster 在每个时间点对应的细胞标记
    
    merge_temp = [];
    for j = 1:length(Budding)
        if Lineages_temp.Lineage_index(j) == 0
            temp = 0;
        else
            temp = Budding(j).merge(Lineages_temp.Lineage_index(j));
        end
        merge_temp = [merge_temp temp];
    end
    
    if max(merge_temp) > 0
        continue
    end
    
    
    area1 = Get_Properities(1:length(Lineages_temp.Lineage_index), Lineages_temp.Lineage_index, 'area', Budding);  
    area1_RFP = Get_Properities(1:length(Lineages_temp.Lineage_index), Lineages_temp.Lineage_index, 'RFP', Budding); 
    % Get_Properities(1:total_time_point, label_in_each_time_point, 'area', Budding)
    n=n+1;
    name = [name i];
    
    all_valid_area = [ all_valid_area table(area1', 'VariableNames',{['cell_cluster' num2str(i)]}) ]  ;  
    all_valid_area_RFP = [ all_valid_area_RFP table(area1_RFP', 'VariableNames',{['cell_cluster' num2str(i)]}) ]  ;  
    
    
    
    subplot(1,2,1); hold on;
    plot(area1(1:end-1),'Linewidth',2)
    subplot(1,2,2); hold on;
    plot(area1(1:end-1),'Linewidth',2)
    
    
end

subplot(1,2,1); hold on;
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Clone Area');
subplot(1,2,2); hold on;
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Clone Area (log)');
set(gca,'yscale','log');
