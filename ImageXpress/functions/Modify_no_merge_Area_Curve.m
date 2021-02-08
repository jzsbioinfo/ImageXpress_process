
function [all_valid_area all_valid_area_RFP] =  Modify_no_merge_Area_Curve(Budding,I)

if max(I)>length(Budding(1).area)
    I = 1:length(Budding(1).area);
end
hold on; set(gcf,'color','w','position',[50 500 400*2 300]);  hold on;


% for every cell cluster in the last segmentation figure
all_valid_area = table()
all_valid_area_RFP = table()

n = 0
name = []

for i= I

    Lineages_temp = Modify_Lineage_forward(Budding,length(Budding),i); % 使用lineage_找到 cell cluster 在每个时间点对应的细胞标记
    
    merge_temp = [];
    for j = 1:length(Budding)
        
        if Lineages_temp.Lineage_index(j) == 0
            temp = 0;
        else
            temp = Budding(j).merge(Lineages_temp.Lineage_index(j));
        end
        merge_temp = [merge_temp temp];
    end
    
%     if max(merge_temp) > 0
%         continue
%     end
    
    
    area1 = Get_Properities(1:length(Lineages_temp.Lineage_index), Lineages_temp.Lineage_index, 'area', Budding);  
    area1_RFP = Get_Properities(1:length(Lineages_temp.Lineage_index), Lineages_temp.Lineage_index, 'RFP', Budding); 
    
    
    
    % after merge time point, all merge area to 0
    for k = 1:(length(merge_temp)-1)
        if merge_temp(k) >0
            merge_temp(k:length(merge_temp)) = 1;
        end
        if merge_temp(k)==0 & merge_temp(k+1)>0
            merge_temp(k+1) = 0;
            merge_temp((k+2):length(merge_temp)) = 1;
            break
        end
    end
        
    area1= area1.*double(~merge_temp);
    area1_RFP= area1_RFP.*double(~merge_temp);
    
    if min(area1 < 0)
        area1
    end
    
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

% name2 = {}
% for i = 1:length(name)
%     name2(i) = {['cell_cluster' '_' num2str(name(i))]};
% end
%     
% all_valid_area.Properties.VariableNames = name2
% 
% 
% 
% name3 = {}
% for i = 1:length(name)
%     name3(i) = {['cell_cluster_RFP' '_' num2str(name(i))]};
% end
% 
% all_valid_area_RFP.Properties.VariableNames = name3




subplot(1,2,1); hold on;
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Clone Area');
subplot(1,2,2); hold on;
set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
xlabel('time');
ylabel('Clone Area (log)');
set(gca,'yscale','log');
