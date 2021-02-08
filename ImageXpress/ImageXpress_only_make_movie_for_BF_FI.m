% 20191026 make raw images into movies
clc; clear;
%% set wells, time points, data store dir
well_col = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"]

%well_col = ["07" "08" "09" "10" "11" "12"]
% 
well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]
%well_row = flip(well_row)
%well_row = ["C"]
well_col = ["07" "08" "09" "10" "11" "12"]
% well_col = [ "02"]
% well_row = ["D"]

well_row = ["B" "C" "F" "G"]


well_col = ["02" "03" "04" "05" "06" "07" "08" "09"]




well_row = ["B" ]

well_col = [ "09"]





well_names=[]

for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);
    end
end   

% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 20;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\18th_40X_does_high_mCherry_high_PDR5_resistant\TL_mCherry\'



%% for loop for each well
for well = well_names


%%% TO CHANGE
% Specify the name of the well (folder name).
Name_case_ori     = char(well); 

Name_case_ori
%% Step 1. Image segmentation.

%%% 1. Load the directory for microscope images.

addpath('./functions/');


% Specify the directory to all the microscope images.
Path    = ['Z:\MD\18th_40X_does_high_mCherry_high_PDR5_resistant\20191205 ping_276\TimePoint_*\'];


%% BF
% files----------------------------------------------------------------------------------------------------------
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

%% FI1
% files--------------------------------------------------------------------------------------------------------
Image_Type2 = '_w3.tif';     % use TL25 or YFP 

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
 

 
I     = imread([Files(i).folder '/' Files(i).name]);

I_FI = imread([Files2(i).folder '/' Files2(i).name]);
% if exist('mask')
%     I     = I.*mask;
% end

toc;




tic;

fuse_image_less = Merge_and_adjust_only_for_BF_FI(I, I_FI);  % fuse_image is fuse of BF seg FI label, fuse_image_less is fuse of BF FI

% for cell_i = 1:length(Budding(1).centroid)
% 
%         Cell_xy   = Budding(1).centroid(cell_i).Centroid;
%         
%         fuse_image_less = insertText(fuse_image_less, Cell_xy, cell_i);
%         
% end
    
fuse_image_less_cell{i} = fuse_image_less;
%imwrite(fuse_image,[date_folder Name_case '\BF_Seg_FI_' num2str(i.','%02d') Files(i).folder((end-10):end) '_fuse' '.png'], 'png' );
    
end

toc;

%{


%}

%% make movie for fuse_image_less


% Create New Video with the Image Sequence

outputVideo = VideoWriter([date_folder char(well) 'BF_FI_out.avi']);
outputVideo.FrameRate = 0.5;
open(outputVideo)

% Loop through the image sequence, load each image, and then write it to the video.
for i = 1:length(fuse_image_less_cell)
    
   img = im2double(fuse_image_less_cell{i});
   %img = imresize(img, [6001 NaN]);  % save 6001*6001
   %img = im2frame(img);
   writeVideo(outputVideo,img);
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

