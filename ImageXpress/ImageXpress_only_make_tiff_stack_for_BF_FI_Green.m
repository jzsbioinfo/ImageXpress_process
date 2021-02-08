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

well_col = ["03" "04" "05" "06" "08"]





well_row = ["E"]


well_col = ["02" "03" "04" "05" "06" "07"]


well_row = ["B" "C" "D"]

well_col = ["02" "03" "04" "05" "06" "07" "08" "09"]


well_row = ["E" "F" "G" "H"]


well_col = ["01" "02" "04" "05"]




well_names=[]

for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);
    end
end   

well_names1 = well_names
well_names2 = well_names
well_names = [well_names1 well_names2]

% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 1;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\14th_reversible_40X\rever-test3_257\'



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
Path    = ['Z:\MD\14th_reversible_40X\20191114  rever-test3_257\TimePoint_*\'];


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


outputVideo = VideoWriter([date_folder char(well) '_BF_FI_out.avi']);
outputVideo.FrameRate = 1;
open(outputVideo)
%%% TO CHANGE
for i =  start_time_point:Tif_Window.T
   close all;
 

 
I     = imread([Files(i).folder '/' Files(i).name]);

I_FI = imread([Files2(i).folder '/' Files2(i).name]);

% I = imread('Z:\MD\9th_20191003_TL25_mCherry\20190930_187\TimePoint_1\20190930_A01_w1.tif');
% 
% I_FI = imread('Z:\MD\9th_20191003_TL25_mCherry\20190930_187\TimePoint_1\20190930_A01_w2.tif');
% 


% Adjust the contrast based on the image value range, this ref the imagej
%BF
I = im2double(I);

% max_I = max(max(I));
% min_I = min(min(I));
% diff = max_I-min_I;
% 
% I = (I-min_I)/diff;

% imshow(I)
% imshow(I_FI*20)
% FI
I_FI = im2double(I_FI);


% figure
% imshow(I_FI*10)
%I_FI = I_FI*100;
%I_FI = I_FI*40;
% I_FI = I_FI*10;
% imagej adjust
% max_I_FI = max(max(I_FI));
% min_I_FI = min(min(I_FI));
% diff = max_I_FI-min_I_FI;
% 
% I_FI = (I_FI-min_I_FI)/diff;
 


% figure
% I_FI_t = I_FI*100;
fuse_image_less = Merge_only_for_BF_FI_Green(I*3 , I_FI*2);

% figure
% imshow(fuse_image_less)
fuse_image_less(fuse_image_less>1) = 1;
% fuse_image is fuse of BF seg FI label, fuse_image_less is fuse of BF FI
% if exist('mask')
%     I     = I.*mask;
% end
% imwrite(fuse_image_less, filename, 'WriteMode', 'append',  'Compression','none');
writeVideo(outputVideo,fuse_image_less);






%{


%}
end
close(outputVideo)
toc;

end