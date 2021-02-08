

function RHX_0_Show_Last_Image_Cells(Budding)
figure; hold on;

 for cell_i = 1:length(Budding(end).centroid)

        Cell_xy   = Budding(end).centroid(cell_i).Centroid;
        Cell_ROI  = Budding(end).ROIs(cell_i).ConvexHull;

        plot(Cell_ROI(:,1),Cell_ROI(:,2),'b-','markersize',5);
         plot(Cell_xy(1),Cell_xy(2),'r.','markersize',20);
        text(Cell_xy(1),Cell_xy(2),num2str(cell_i),'fontsize',10);
        title(['t = ' num2str(length(Budding)) ' ( time point )']);
axis image;
axis off;
 end