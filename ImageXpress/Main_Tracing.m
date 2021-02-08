%%%%%% Step 1. Image segmentation.
%% MUST RUN SECTION
%%% 1. Load the directory for microscope images.
clc; clear;
addpath('./functions/');

%%% TO CHANGE
% Specify the name of the well (folder name).
Name_case_ori     = 'C4'; 

% Specify the region that you want to look at by using "Rectangle"
% tool in ImageJ to get the pixel coordinate.
Tif_Window.xlim   = [2744 2744+3456]; % [x x+w]
Tif_Window.ylim   = [2400 2400+2888];% [y y+h]

% Specify the total number of timepoints in the folder 
% or the number of timepoints you want to check.
Tif_Window.T      = 16;

% Specify the directory to all the microscope images.
Path    = ['Z:\2019073 3rd FLC experiment\Images\' Name_case_ori '\'];
%%% END

Image_Type = '*_O_Bf_*.tif*';

%-----------------------------%


Files     = dir([Path Image_Type]);
Name_case = [Name_case_ori Image_Type(2:end-6)];


Temp = Files;

for i = 1 : length(Files)
    s = regexp(Temp(i).name,'_');
    Files(str2num(Temp(i).name((s(2)+1):(s(3)-1)))) = Temp(i);
end

% Make a folder to store the cut images.
if exist(Name_case); rmdir(Name_case,'s'); end
mkdir(Name_case);
%% save RFP images 
%{
% tic;
% for i =  1:Tif_Window.T
%        close all;
%           i
%     I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%     imwrite(uint16(I),[Name_case '/Cut_BF_' Files(i).name(1:end-5) '.tif'], 'tif' );
% 
% end
% toc;
%}

%% Identify Circle Edge
% You might need to ask Huixia about this.
mask = uint16(Modify_Clone_Mask(imread([Files(1).folder '/' Files(1).name])));

%% MUST RUN
%%% 2. Recognize the yeast cells and cut the images.
tic;

%%% TO CHANGE
for i =  1:Tif_Window.T
%%% END
   close all;
 i
I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
if exist('mask')
    I     = I.*mask;
end
I_old = I;

% % ----------- cells in previous image must be cells in next image
% mask_old    = Budding(i-1).mask;
% I(mask_old) = max(I(:));
% % ----------- 

toc;
tic;

%%% TO CHANGE
Params.fudgeFactor        = 0.8;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 100;
%%% END

BWfinal = Clone_RHX(I,Params);


% % ----------- cells in after image must be cells in previous image
% mask_old    = Budding(60).mask;
% BWfinal     = mask_old&BWfinal;
% % ----------- 


% ==============
figure;
imshowpair(I_old,BWfinal)
title(['t = ' num2str(i) ' ( time point )']);
% ==============



imwrite(uint16(I),[Name_case '/Cut_BF_' Files(i).name(1:end-5) '.tif'], 'tif' );
imwrite(uint16(BWfinal),[Name_case '/Cut_Seg_' Files(i).name(1:end-5) '.tif'], 'tif' );


    Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
    Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
    Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
    Budding(i).mask             = BWfinal;  % find boundary for each cell

end

toc;

% Get Each RFP and GFP
disp('Finished !!');

%% 3.Store the data and record the GFP/RFP intensity.

%%% MUST RUN THIS LINE if you want to record GFP/RFP instensity
Budding = Budding_RFP_GFP(Budding,Name_case_ori,Path,Tif_Window);
% Note that the function Budding_RFP_GFP might need to be changed 
% if there is no *_G_*.tiff or *_R_*.tiff files in the folder.


save([Name_case '.mat']);
disp('Finished !!');

% figure;
% imshow(Budding(33).mask)

%%%%%% END OF STEP 1

%% MUST RUN
%%%%%% step 2. Trace every clone
Budding = Yeastbow_find_mother(Budding);
RHX_0_Show_Last_Image_Cells(Budding);

%% MUST RUN
%%%%%% step 3. show growth curves
figure; 

% 这个的上限其实是瞎设置的 反正也没有1000个
RHX1_Area_Curve(Budding,1:1000);

%% MUST RUN
%%% step 4. Play with specific patches
%%% TO CHANGE
% The 
Lineages = Lineage(Budding,length(Budding),32);
%%% END

figure;
RHX2_Growth_Area(Lineages,Budding);

% If there is no *_G_*.tiff or *_R_*.tiff images in the folder, 
% there might be an error.
%RHX4_RFP_GFP(Budding,Lineages);


%% step 5. video

Position.xlim   = [Tif_Window.xlim - min(Tif_Window.xlim)];
Position.ylim   = [Tif_Window.ylim - min(Tif_Window.ylim)];

close all; figure; hold on; set(gcf,'color','w','position',[50 100 600*2 500]);  hold on;
RHX3_show_lineage(Budding,Lineages,Position,Name_case)



%% save 

save([Name_case '.mat']);
disp('Finished !!');

%{
% [Files_BF, Files_GFP, Files_RFP] = GetImageNames(Name_case_ori,Path);
% 
% if exist([Name_case(1:end-3) 'G']); rmdir([Name_case(1:end-3) 'G'],'s'); end; mkdir([Name_case(1:end-3) 'G']);
% if exist([Name_case(1:end-3) 'R']); rmdir([Name_case(1:end-3) 'R'],'s'); end; mkdir([Name_case(1:end-3) 'R']);
% 
% 
% for i =  1:Tif_Window.T
%     I_BF     = imread([Files_BF(i).folder '/' Files_BF(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%     I_GFP    = imread([Files_GFP(i).folder '/' Files_GFP(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%     I_RFP    = imread([Files_RFP(i).folder '/' Files_RFP(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%     
%     imwrite(uint16(I_BF),[Name_case '/Cut_BF_' Files(i).name(1:end-5) '.tif'], 'tif' );
%     imwrite(uint16(I_GFP),[Name_case(1:end-3) 'G' '/Cut_G_' Files(i).name(1:end-5) '.tif'], 'tif' );
%     imwrite(uint16(I_RFP),[Name_case(1:end-3) 'R' '/Cut_R_'  Files(i).name(1:end-5) '.tif'], 'tif' );
%     imwrite(uint16( Budding(i).mask),[Name_case '/Cut_Seg_' Files(i).name(1:end-5) '.tif'], 'tif' );
% end
% disp('Finished !!');
%}