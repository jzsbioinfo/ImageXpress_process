
function RHX4_RFP_GFP(Budding,Lineages)

GFP = Get_Properities(1:length(Lineages.Lineage_index),Lineages.Lineage_index,'GFP',Budding);
RFP = Get_Properities(1:length(Lineages.Lineage_index),Lineages.Lineage_index,'RFP',Budding);
area1 = Get_Properities(1:length(Lineages.Lineage_index),Lineages.Lineage_index,'area',Budding);
    T = 1:length(area1);
    
figure;
set(gcf,'color','w','position',[946 242 400*2 350]);  hold on;
  
subplot(1,2,1);
h_gfp = plotyy(T,area1,T,GFP);
h_gfp(1).YColor = 'k';
h_gfp(1).YAxis.Scale = 'log';
h_gfp(1).LineWidth    = 2;
h_gfp(1).Children(1).Color='k';
h_gfp(1).Children(1).LineWidth=2;
h_gfp(1).YLabel.String = 'Clone Area';
h_gfp(1).FontSize = 15;
h_gfp(1).FontName = 'Times New Roman';

h_gfp(2).YColor = [0 .5 0];
h_gfp(2).LineWidth = 2;
h_gfp(2).Children(1).Color=[0 .5 0];
h_gfp(2).Children(1).LineWidth=2;
h_gfp(2).YLabel.String = 'Clone GFP';
h_gfp(2).FontSize = 15;
h_gfp(2).FontName = 'Times New Roman';

subplot(1,2,2);
h_rfp = plotyy(T,area1,T,RFP);
h_rfp(1).YColor = 'k';
h_rfp(1).YAxis.Scale = 'log';

h_rfp(1).LineWidth    = 2;
h_rfp(1).Children(1).Color='k';
h_rfp(1).Children(1).LineWidth=2;
% h_rfp(1).YLabel.String = 'Clone Area';
h_rfp(1).FontSize = 15;
h_rfp(1).FontName = 'Times New Roman';

h_rfp(2).YColor = 'r';
h_rfp(2).LineWidth = 2;
h_rfp(2).Children(1).Color='r';
h_rfp(2).Children(1).LineWidth=2;
h_rfp(2).YLabel.String = 'Clone RFP';
h_rfp(2).FontSize = 15;
h_rfp(2).FontName = 'Times New Roman';

%     plot(area1,'k','Linewidth',2)



% set(gca,'Linewidth',1,'FontSize',18,'FontName','Times New Roman','xticklabelrotation',45);
% xlabel('time');
% ylabel('Clone Area');
