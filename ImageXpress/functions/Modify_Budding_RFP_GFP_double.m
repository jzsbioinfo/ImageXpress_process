
function Budding = Modify_Budding_RFP_GFP_double(Budding,Name_case_ori,Path,Tif_Window,Files_num,RFP_data, GFP_data)

Image_Type2 = RFP_data;
Files_RFP = Modify_GetImageNames_double(Name_case_ori,Path,Files_num, Image_Type2);

Image_Type3 = GFP_data;
Files_GFP = Modify_GetImageNames_double(Name_case_ori,Path,Files_num, Image_Type3);


tic;
for i = 1:Tif_Window.T
    
    I_RFP     = imread([Files_RFP(i).folder '/' Files_RFP(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
    I_GFP     = imread([Files_GFP(i).folder '/' Files_GFP(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
    ss        = regionprops(Budding(i).mask, 'PixelIdxList');        % find position for each cell

    for j=1:length(ss)
        ID = ss(j).PixelIdxList;
        
        Budding(i).RFP(j).RFP = mean(I_RFP(ID)); 
        
        Budding(i).GFP(j).GFP = mean(I_GFP(ID));
    end
    
end
toc;
disp('Finished !!');
