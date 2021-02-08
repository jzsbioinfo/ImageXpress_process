
function Fission = Yeastbow_PCA_angle(Fission)


% figure; hold on;xlim([0 512]);ylim([0 512]);


for t = 1:length(Fission)
    for cell_i = 1:length(Fission(t).centroid)
        Cell_xy  = Fission(t).centroid(cell_i).Centroid;
        Cell_ROI = Fission(t).ROIs(cell_i).ConvexHull;
        Cell_k   = tan(-Fission(t).Orient(cell_i).Orientation);
        
        %         [x y] = find(Fission(t).BW==cell_i);
        x = Cell_ROI(:,1);
        y = Cell_ROI(:,2);
        
        [coeff,score,latent] = pca([x,y]);
        Cell_k    = coeff(2,1)/coeff(1,1);
        Cell_k2   = coeff(2,2)/coeff(1,2);
        
        if (90-abs(atan(Cell_k)/pi*180))<4
            Ori    = sign(atan(Cell_k)/pi*180)*86;
            Cell_k = tan(Ori/180*pi);
            Cell_k2 = tan((Ori+90)/180*pi);
        end
        
        x1 = [ Cell_ROI(:,1) ];
        x1 = [min(x1):(max(x1)-min(x1))/100 : max(x1)];
        y1 = [x1-Cell_xy(1)]*Cell_k+[Cell_xy(2)];
        
        
        I  = inpolygon(x1,y1,x,y);
        if sum(I)<4
            x1 = [min(x1):(max(x1)-min(x1))/10000 : max(x1)];
            y1 = [x1-Cell_xy(1)]*Cell_k+[Cell_xy(2)];
            I  = inpolygon(x1,y1,x,y);
        end
        x1 = x1(I);
        y1 = y1(I);
        
        x_s2 = [min(Cell_ROI(:,1) ):(max(Cell_ROI(:,1) )-min(Cell_ROI(:,1) ))/100 : max(Cell_ROI(:,1) )];
        y_s2 = [x_s2-Cell_xy(1)]*Cell_k2+[Cell_xy(2)];
        I  = inpolygon(x_s2,y_s2,x,y);
        if sum(I)<4
            x_s2 = [min(Cell_ROI(:,1) ):(max(Cell_ROI(:,1) )-min(Cell_ROI(:,1) ))/10000 : max(Cell_ROI(:,1) )];
            y_s2 = [x_s2-Cell_xy(1)]*Cell_k2+[Cell_xy(2)];
            I  = inpolygon(x_s2,y_s2,x,y);
        end
        
        x_s2 = x_s2(I);
        y_s2 = y_s2(I);
        %
%                 plot(x1,y1);
%                 plot(Cell_ROI(:,1),Cell_ROI(:,2),'r+');
%                 plot(Cell_xy(1),Cell_xy(2),'ro');
%                 plot(x1(1),y1(1),'k*');
%                 plot(x1(end),y1(end),'k*');
%                 plot(x_s2,y_s2);
%                 plot(x_s2(1),y_s2(1),'k^');
%                 plot(x_s2(end),y_s2(end),'k^');
%         
        Fission(t).k(cell_i).k           = Cell_k;
        Fission(t).Orient(cell_i).Orient = atan(Cell_k)/pi*180;
        Fission(t).Heads(cell_i).Heads   = [x1([1]) y1([1])]';
        Fission(t).Ends(cell_i).Ends     = [x1([end]) y1([end])]';
        Fission(t).k2(cell_i).k2         = Cell_k2;
        Fission(t).Up(cell_i).Up         = [x_s2([1]) y_s2([1])]';
        Fission(t).Down(cell_i).Down     = [x_s2([end]) y_s2([end])]';
        
        Fission(t).MajorAxisLength(cell_i).MajorAxisLength = dist([x1([1]) y1([1])],[x1([end]) y1([end])]');
        Fission(t).MinorAxisLength(cell_i).MinorAxisLength = dist([x_s2([1]) y_s2([1])],[x_s2([end]) y_s2([end])]');
    end
end