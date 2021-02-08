
function Budding = Budding_RFP_GFP(Budding,Name_case_ori,Path,Tif_Window,Files_num)

Files_RFP = Modify_GetImageNames(Name_case_ori,Path,Files_num);

tic;
for i = 1:Tif_Window.T
    
    I_RFP     = imread([Files_RFP(i).folder '/' Files_RFP(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
    ss        = regionprops(Budding(i).mask, 'PixelIdxList');        % find position for each cell

    for j=1:length(ss)
        ID = ss(j).PixelIdxList;
        Budding(i).GFP(j).GFP = mean(I_GFP(ID));
        Budding(i).RFP(j).RFP = mean(I_RFP(ID));     
    end
    
end
toc;
disp('Finished !!');
