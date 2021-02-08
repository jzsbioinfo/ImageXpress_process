

Path    = ['E:\Project\2019__MitochondriaHeterogeneityHeritability\Software\YeastColonyTracking__Matlab_pipeline\20191007_20190929_TL25_YFP_all\H01_w1\'];


% read in all BF image and Seg image

Image_Type1 = 'Cut_BF*';     % use TL25 or YFP 

Image_Type2 = 'Cut_Seg*';  
% all figures directory

Files_BF     = dir([Path Image_Type1]);

Files_Seg     = dir([Path Image_Type2]);



if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
mkdir([date_folder Name_case]);

%% label Seg image

for i =  1:length(Files_BF)

 

I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});





end


%% merge BF and labeled Seg image





























