
clc; clear;

% Name_case_ori ='A2';
% Tif_Window.xlim   = [3288 3288+2648];
% Tif_Window.ylim   = [4190 4190+1616];
% Tif_Window.T      = 30;

% Name_case = 'D2';
% Tif_Window.xlim   = [1 2000];
% Tif_Window.ylim   = [3000 3000+2000];

Name_case_ori = 'F11';
Tif_Window.xlim   = [3288 3288+3648];
Tif_Window.ylim   = [4190 4190+3500];
Tif_Window.T      = 7;

% Name_case_ori ='B2';
% Tif_Window.xlim   = [3824 3824+2640];
% Tif_Window.ylim   =  [684 684+2952];
% Tif_Window.T      = 33;

% Name_case_ori ='B4';
% Tif_Window.xlim   = [708 708+3200];
% Tif_Window.ylim   = [3727 3727+2800];
% Tif_Window.T      = 30;


% Name_case_ori ='C1';
% Tif_Window.xlim   = [6096 6096+1040];
% Tif_Window.ylim   = [2752 2752+1040];
% Tif_Window.T      = 40;


% Name_case_ori ='C2';
% Tif_Window.xlim   = [3288 3288+2648];
% Tif_Window.ylim   = [4190 4190+1616];
% Tif_Window.T      = 25;


% Name_case_ori     = 'E11';
% Tif_Window.xlim   = [984 984+8172];
% Tif_Window.ylim   = [2436 2436+6036];
% Tif_Window.T      = 16;



Image_Type = '*_O_Bf_*.tiff';
% Image_Type = '*_O_G_*.tiff';
% Image_Type = '*_O_R_*.tiff';

%-----------------------------%
% Path  = ['G:\' Name_case_ori '\'];
% 

Path  = ['J:\RHX_Project\Lucas\data\'];

Files     = dir([Path Image_Type]);
Name_case = [Name_case_ori Image_Type(2:end-6)];


Temp = Files;

for i = 1 : length(Files)
    s = regexp(Temp(i).name,'_');
    Files(str2num(Temp(i).name((s(2)+1):(s(3)-1)))) = Temp(i);
end


if exist(Name_case); rmdir(Name_case,'s'); end
mkdir(Name_case);
%% Simpleset Case
    
tic;

for i =  1:6%1:Tif_Window.T
   close all;
 i
I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
I_old = I;

% % ----------- cells in previous image must be cells in next image
% mask_old    = Budding(i-1).mask;
% I(mask_old) = max(I(:));
% % ----------- 

toc;
tic;

Params.fudgeFactor        = 0.6;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 200;

BWfinal = Clone_RHX(I,Params);


% % ----------- cells in after image must be cells in previous image
% mask_old    = Budding(i+1).mask;
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

%%
% Budding = Budding_RFP_GFP(Budding,Name_case_ori,Path,Tif_Window);

save([Name_case '.mat']);
disp('Finished !!');


% figure;
% imshow(Budding(33).mask)

%% step 2. Trace every clone
Budding = Yeastbow_find_mother(Budding);
RHX_0_Show_Last_Image_Cells(Budding);

%% step 3. show growth curves
figure; 
RHX1_Area_Curve(Budding,1:1000)
% RHX1_Area_Curve(Budding,112)

%% step 4. Play with specific patches
Lineages = Lineage(Budding,length(Budding),92);

figure;
RHX2_Growth_Area(Lineages,Budding);

% RHX4_RFP_GFP(Budding,Lineages);
%% step 5. video
% Lineages = Lineage(Budding,length(Budding),16);

Position.xlim   = [Tif_Window.xlim - min(Tif_Window.xlim)];
Position.ylim   = [Tif_Window.ylim - min(Tif_Window.ylim)];

close all; figure; hold on; set(gcf,'color','w','position',[50 100 600*2 500]);  hold on;
RHX3_show_lineage(Budding,Lineages,Position,Name_case)


%%

%% save 
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
