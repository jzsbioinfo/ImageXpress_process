% 20191029 make raw images into movies
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
well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]
well_col = ["07" "08" "09" "10" "11" "12"]


well_col = ["03" "04" "05" "06" "08"]


well_row = ["C" "D" "E"]


well_col = ["03" "04" "06" "08" "09"]

well_row = ["B"]


well_names=[]
for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);


    end
end   

well_names1 = well_names;
well_names2 = well_names;
well_names = [well_names1 well_names2];



% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 20;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\12th_TL25_mCherry_40X\mCherry\'



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
Path    = ['Z:\MD\12th_TL25_mCherry_40X\20191031 40X_246\TimePoint_*\'];


% %% BF
% % files----------------------------------------------------------------------------------------------------------
% Image_Type = '_w1.tif';     % use TL25 or YFP 
% 
% % all figures directory
% Name_case = [Name_case_ori Image_Type];
% Name_case = ['*_' Name_case]
% Files     = dir([Path Name_case]);
% 
% 
% Temp = Files;
% % order the figures by time point
% for i = 1 : length(Files)
% 
%     s = regexp(Temp(i).folder,'TimePoint');
%     Files(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);
% end
% 
% % no interval 
% Files_num = 1:1:20;
% % 30 mins interval------
% % Files_num = 2:2:80
% % Files = Files(Files_num);
% 
% Tif_Window.T = end_point;
% 
% start_time_point = start_point;
% 
% % Make a folder to store the cut images.
% Name_case = Name_case(3:8)
% % if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
% % mkdir([date_folder Name_case]);

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

%% Recognize the yeast cells and cut the images.     10X-------------------------------------------------------------
% tic;
% 
% Tif_Window.xlim   = [888 888+6000];      % [x x+w]
% Tif_Window.ylim   = [888 888+6000];      % [y y+h]
% 
% outputVideo = VideoWriter([date_folder char(well) 'FI_out.avi']);
% outputVideo.FrameRate = 1;
% open(outputVideo)
% %%% TO CHANGE
% for i =  start_time_point:Tif_Window.T
%    close all;
%    
%    i=1;
%    
%  
%    img = imread([Files2(i).folder '/' Files2(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%    figure
%    imshow(imadjust((img)))
% 
%    img = imadjust(im2double(img));
% 
%    %img = imresize(img, [6001 NaN]);  % save 6001*6001
%    %img = im2frame(img);
%    writeVideo(outputVideo,img);
% end
% 
% close(outputVideo)



%% Recognize the yeast cells and cut the images.     40X-------------------------------------------------------------
tic;


outputVideo = VideoWriter([date_folder char(well) '_FI_out.avi']);
outputVideo.FrameRate = 1;
open(outputVideo)
%%% TO CHANGE
for i =  start_time_point:Tif_Window.T
   close all;
 


I_FI = imread([Files2(i).folder '/' Files2(i).name]);

% Adjust the contrast based on the image value range, this ref the imagej


% FI
I_FI = im2double(I_FI);

max_I_FI = max(max(I_FI));
min_I_FI = min(min(I_FI));
diff = max_I_FI-min_I_FI;

I_FI = (I_FI-min_I_FI)/diff;







% fuse_image is fuse of BF seg FI label, fuse_image_less is fuse of BF FI
% if exist('mask')
%     I     = I.*mask;
% end
% imwrite(fuse_image_less, filename, 'WriteMode', 'append',  'Compression','none');
writeVideo(outputVideo,I_FI);






%{


%}
end
close(outputVideo)
toc;



    
end

toc;

%{


%}

%% make movie for fuse_image_less


% Create New Video with the Image Sequence


% save last segmentation figure

% savedir = 'E:\Project\2019__MitochondriaHeterogeneityHeritability\Software\YeastColonyTracking__Matlab_pipeline\';
% figure;
% imshow(BWfinal);
% title([Name_case_ori ' t = ' num2str(i) ' ( time point )']);
% saveas(gcf, fullfile(savedir,'\BW_final\',[Name_case_ori 'segmentation.png']))
% close all
% disp('Finished !!');

%%

 

