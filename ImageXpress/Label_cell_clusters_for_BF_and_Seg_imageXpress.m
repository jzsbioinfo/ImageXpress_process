%% 2019 11 20 forward calculation to deal with merge event

clc; clear;
%% all wells need to process

%well_col = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"]

%well_col = ["07" "08" "09" "10" "11" "12"]
% 
%well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]


well_col = ["02" "03" "04" "05" "06" "07" "08"]
well_row = ["B" "C" "D" "E" "F" "G"]


well_names=[]

for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);
    end
end   

% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 30;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\31th_20X\segmentation_FI\'


%% parfor loop for each well
for well = well_names

well = "B02";
%%% TO CHANGE
% Specify the name of the well (folder name).
Name_case_ori     = char(well); 

Name_case_ori
%% Step 1. Image segmentation.

%%% 1. Load the directory for microscope images.

addpath('./functions/');





% Specify the directory to all the microscope images.
Path    = ['Z:\MD\31th_20x\20201209-20x_513\TimePoint_*\'];

Image_Type = '_w1.tif';     % use TL25 or YFP 

% all figures directory
Name_case = [Name_case_ori Image_Type];
Name_case = ['*_' Name_case]
Files     = dir([Path Name_case]);


Temp = Files;
% order the figures by time point
for i = 1 : length(Files)

    s = regexp(Temp(i).folder,'TimePoint');
    Files(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);
end

% no interval 
Files_num = 1:1:30;
% 30 mins interval------
% Files_num = 2:2:80
% Files = Files(Files_num);



% Files_num = []
% for i = 1:length(Files)
%     s = regexp(Files(i).folder,'_');
%     Files_num = [Files_num, str2num(Files(i).folder((s(2)+1):end))]
% end

% reverse order the pictures to reverse read the pictures
%Files(1:length(Files)) = Files(length(Files):-1:1)


Tif_Window.T = end_point;

start_time_point = start_point;



% Make a folder to store the cut images.
Name_case = Name_case(3:8)
% if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
% mkdir([date_folder Name_case]);


%% FI1
% files--------------------------------------------------------------------------------------------------------
Image_Type2 = '_w2.tif';     % use TL25 or YFP 

% all figures directory
Name_case = [Name_case_ori Image_Type2];
Name_case = ['*_' Name_case]
Files2     = dir([Path Name_case]);


Temp = Files2;
% order the figures by time point
for i = 1 : length(Files2)

    s = regexp(Temp(i).folder,'TimePoint');
    Files2(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);
end

% no interval 
Files2_num = 1:1:20;
% 30 mins interval------
% Files2_num = 2:2:80
% Files2 = Files2(Files2_num);

Tif_Window.T = end_point;

start_time_point = start_point;

%% FI2
% files--------------------------------------------------------------------------------------------------------
Image_Type3 = '_w3.tif';     % use TL25 or YFP 

% all figures directory
Name_case = [Name_case_ori Image_Type3];
Name_case = ['*_' Name_case]
Files3     = dir([Path Name_case]);


Temp = Files3;
% order the figures by time point
for i = 1 : length(Files3)

    s = regexp(Temp(i).folder,'TimePoint');
    Files3(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);
end

% no interval 
Files3_num = 1:1:20;
% 30 mins interval------
% Files2_num = 2:2:80
% Files2 = Files2(Files2_num);

Tif_Window.T = end_point;

start_time_point = start_point;



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

%% Recognize the yeast cells and cut the images.


outputVideo = VideoWriter([date_folder char(well) '_BF_FI_label_out.avi']);
outputVideo.FrameRate = 1;
open(outputVideo)

outputVideo_compress = VideoWriter([date_folder char(well) '_BF_FI_label_out_compress.avi']);
outputVideo_compress.FrameRate = 1;
open(outputVideo_compress)

%%% TO CHANGE
for i =  start_time_point:Tif_Window.T
   close all;

 
 

i=10;
% Identify Circle Edge and use the center  of the Circle to find the image area to use

% mask = uint16(Modify_Clone_Mask(imread([Files(i).folder '/' Files(i).name])));
% 
% mask
% Specify the region that you want to look at by using "Rectangle" tool in ImageJ to get the pixel coordinate.

% use a square of 6000*6000, x=1710, y=2255
% Tif_Window.xlim   = [mask(1)-3000 mask(1)+3000];      % [x x+w]
% Tif_Window.ylim   = [mask(2)-3000 mask(2)+3000];      % [y y+h]
% 


% use determinated area, because no circle edge in the image
Tif_Window.xlim   = [0 9720];      % [x x+w]
Tif_Window.ylim   = [0 9720];      % [y y+h]
 
 
I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});


I_FI = imread([Files2(i).folder '/' Files2(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});

I_FI2 = imread([Files3(i).folder '/' Files3(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});


% if exist('mask')
%     I     = I.*mask;
% end
% I_old = I;

% % ----------- cells in previous image must be cells in next image
% mask_old    = Budding(i-1).mask;
% I(mask_old) = max(I(:));
% % ----------- 




% I  = imread('Cut_BF_3TimePoint_1.tif');

% imshow(uint8(I));
% 
% J= uint8(I);

% I_old = I;
%%% TO CHANGE
Params.fudgeFactor        =  0.85;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 300;
%%% END

BWfinal = Clone_RHX(I,Params);


% figure
% imshow(I)
% figure
% imshow(BWfinal)
% figure
% imshowpair(I,BWfinal)
% 
% 
% BWfinal = Clone_RHX(J,Params);
% 
% imshow(BWfinal)
% imshow(uint8(BWfinal))
% max(BWfinal)

% % ----------- cells in after image must be cells in previous image
% mask_old    = Budding(60).mask;
% BWfinal     = mask_old&BWfinal;
% % ----------- 


% ==============

% figure;
% imshowpair(I_old,BWfinal)
% title(['t = ' num2str(i) ' ( time point )']);






%imwrite(uint16(I),[date_folder Name_case '\Cut_BF_' Files(i).folder((end-10):end) '_order' '.tif'], 'tif' );
%imwrite(uint16(BWfinal),[date_folder Name_case '\Cut_Seg_' Files(i).folder((end-10):end) '_order' '.tif'], 'tif' );


    Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
    Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
    Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
    Budding(i).mask             = BWfinal;  % find boundary for each cell

    
%     
% BWfinal_to_uint = im2double(uint16(BWfinal)*65535);
% I = im2double(I);

% 两种方法
% 1. unit16 通过im2double 转换成double, 通过调整荧光强度 Merge_only_for_BF_double(I*3, I_FI*8, I_FI2*2)，然后直接merge，输出double。 
% 2. unit16 , 通过imadjust调整对比度， 直接merge, Merge_and_Adjust_only_for_BF_double(I, I_FI,I_FI2), 输出uint16(Merge),需要变成double。 

% I = im2double(I);
% I_FI = im2double(I_FI);
% I_FI2 =  im2double(I_FI2);

fuse_image_less = Merge_and_Adjust_only_for_BF_double(I, I_FI,I_FI2);

fuse_image_less = im2double(fuse_image_less);

figure
imshow(fuse_image_less)

% for cell_i = 1:min(length(Budding(1).centroid),1000)

% 
% Budding(1).centroid(213).Centroid

% for cell_i = 1:length(Budding(1).centroid)
% 
%         Cell_xy   = Budding(1).centroid(cell_i).Centroid;
%         
%         fuse_image_less = insertText(fuse_image_less, Cell_xy, cell_i);
%         
% end
 
min_num = min(length(Budding(1).centroid),1000);
position = vec2mat([Budding(1).centroid.Centroid],2);
position = position(1:min_num,:);
value = [1:min_num];

fuse_image_less = insertText(fuse_image_less, position, value);
% figure
% imshow(fuse_image_less)
% imshow(im2double(fuse_image_less))


fuse_image_less(fuse_image_less>1) = 1;

writeVideo(outputVideo,fuse_image_less);

fuse_image_less = im2uint8(fuse_image_less);

fuse_image_less = imresize(fuse_image_less,1/4);

writeVideo(outputVideo_compress,fuse_image_less);
% 
% fuse_image = imfuse(I_old,BWfinal_to_uint,'falsecolor','Scaling','independent','ColorChannels',[2 1 2]);
%     
% imwrite(fuse_image,[date_folder Name_case '\BF_Seg' Files(i).folder((end-10):end) '_fuse' '.png'], 'png' );
%     
    
end
close(outputVideo)
close(outputVideo_compress)



 
end



%% this is draft-------------------------------------------------------------
%% label the cell clusters
savedir = './20191011_20191003_TL25_YFP_H01/'
save([savedir Name_case '_Budding' '.mat'], 'Budding' );

%%
figure; hold on;

 for cell_i = 1:length(Budding(1).centroid)

        Cell_xy   = Budding(1).centroid(cell_i).Centroid;
        Cell_ROI  = Budding(1).ROIs(cell_i).ConvexHull;

        %plot(Cell_ROI(:,1),6001-Cell_ROI(:,2),'b-','markersize',1);
        plot(Cell_xy(1),6001-Cell_xy(2),'r.','markersize',5);
        text(Cell_xy(1),6001-Cell_xy(2),num2str(cell_i),'fontsize',5);
        % title(['t = ' num2str(length(Budding)) ' ( time point )']);
axis([0 6001 0 6001]);  % [xmin xmax ymin ymax] 
axis off;
 end
 
 
 %%
 set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6001 6001])
print([savedir Name_case '_label.tif'], '-dtiff' , '-r1')
 
 hold off
 close all