%% 2019 09 02 forward calculation to deal with merge event

clc; clear;
%% all wells need to process

well_col = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"]

%well_col = ["07" "08" "09" "10" "11" "12"]
% 
well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]
%well_row = flip(well_row)
%well_row = ["C"]

% well_col = [ "02"]
% well_row = ["D"]

well_col = ["06"]

well_row = ["B"]

well_names=[]

for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);
    end
end   

% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 1;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\11th_Test 10X 20X 40X MD\20X\'



%% parfor loop for each well
for well = well_names


%%% TO CHANGE
% Specify the name of the well (folder name).
Name_case_ori     = char(well); 

Name_case_ori
%% Step 1. Image segmentation.

%%% 1. Load the directory for microscope images.

addpath('./functions/');


% Specify the directory to all the microscope images.
Path    = ['Z:\MD\9th_20191003_TL25_mCherry\20190930_187\TimePoint_*\'];


% BF
% files----------------------------------------------------------------------------------
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
Files_num = 1:1:20;
% 30 mins interval------
% Files_num = 2:2:80
% Files = Files(Files_num);

Tif_Window.T = end_point;

start_time_point = start_point;

% Make a folder to store the cut images.
Name_case = Name_case(3:8)
% if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
% mkdir([date_folder Name_case]);

% FI
% files--------------------------------------------------------------------------------------------
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

% Make a folder to store the cut images.
Name_case = Name_case(3:8)
if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
mkdir([date_folder Name_case]);
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
tic;

%%% TO CHANGE
for i =  start_time_point:Tif_Window.T
   close all;
 


% Identify Circle Edge and use 
mask = uint16(Modify_Clone_Mask(imread([Files(i).folder '/' Files(i).name])));

mask
 % Specify the region that you want to look at by using "Rectangle" tool in ImageJ to get the pixel coordinate.

% use a square of 6000*6000, x=1710, y=2255
Tif_Window.xlim   = [mask(1)-3000 mask(1)+3000];      % [x x+w]
Tif_Window.ylim   = [mask(2)-3000 mask(2)+3000];      % [y y+h]


 
I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});

I_FI = imread([Files2(i).folder '/' Files2(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
% if exist('mask')
%     I     = I.*mask;
% end
I_old = I;

% % ----------- cells in previous image must be cells in next image
% mask_old    = Budding(i-1).mask;
% I(mask_old) = max(I(:));
% % ----------- 

toc;
tic;


% I  = imread('Cut_BF_3TimePoint_1.tif');

% imshow(uint8(I));
% 
% J= uint8(I);

% I_old = I;
%%% TO CHANGE
Params.fudgeFactor        = 1;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 10;
%%% END

BWfinal = Clone_RHX(I,Params);

%imwrite(uint16(I),[date_folder Name_case '\Cut_BF_' Files(i).folder((end-10):end) '_order' '.tif'], 'tif' );
%imwrite(uint16(BWfinal),[date_folder Name_case '\Cut_Seg_' Files(i).folder((end-10):end) '_order' '.tif'], 'tif' );


    Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
    Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
    Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
    Budding(i).mask             = BWfinal;  % find boundary for each cell

    
 
% BWfinal = uint16(BWfinal);
% 
% fuse_image = imfuse(I_old,BWfinal,'falsecolor','Scaling','independent','ColorChannels',[0 1 2]);
% 
% fuse_image = imfuse(fuse_image,I_FI,'falsecolor','Scaling','independent','ColorChannels',[2 1 1]);

[fuse_image fuse_image_less] = Merge_and_Adjust(I_old, BWfinal, I_FI);  % fuse_image is fuse of BF seg FI label, fuse_image_less is fuse of BF FI

for cell_i = 1:length(Budding(1).centroid)

        Cell_xy   = Budding(1).centroid(cell_i).Centroid;
        
        fuse_image = insertText(fuse_image, Cell_xy, cell_i);
        
end
    
fuse_image_cell{i} =  fuse_image;
fuse_image_less_cell{i} = fuse_image_less;
%imwrite(fuse_image,[date_folder Name_case '\BF_Seg_FI_' num2str(i.','%02d') Files(i).folder((end-10):end) '_fuse' '.png'], 'png' );
    
    
end

toc;


%% make movie for fuse_image_cell



% Create New Video with the Image Sequence
outputVideo = VideoWriter([date_folder char(well) 'time_series_out.avi']);
%outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo)

% Loop through the image sequence, load each image, and then write it to the video.
for i = 1:length(fuse_image_cell)
   img = im2double(fuse_image_cell{i});
   writeVideo(outputVideo,img)
end

close(outputVideo)

fuse_image_cell = {} % clear fuse_image_cell to get more storage space


%% make movie for fuse_image_less



% Create New Video with the Image Sequence
outputVideo = VideoWriter([date_folder char(well) 'BF_FI_out.avi']);
%outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo)

% Loop through the image sequence, load each image, and then write it to the video.
for i = 1:length(fuse_image_less_cell)
   img = im2double(fuse_image_less_cell{i});
   writeVideo(outputVideo,img)
end

close(outputVideo)

fuse_image_less = {} % clear fuse_image_cell to get more storage space

% save last segmentation figure

% savedir = 'E:\Project\2019__MitochondriaHeterogeneityHeritability\Software\YeastColonyTracking__Matlab_pipeline\';
% figure;
% imshow(BWfinal);
% title([Name_case_ori ' t = ' num2str(i) ' ( time point )']);
% saveas(gcf, fullfile(savedir,'\BW_final\',[Name_case_ori 'segmentation.png']))
% close all
% disp('Finished !!');

%%

 
end




%% 















%% 



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