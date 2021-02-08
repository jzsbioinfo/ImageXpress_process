%% 2019 09 02 forward calculation to deal with merge event

clc; clear;
%% all wells need to process

% well_col = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"]
% well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]

% ============================TO CHANGE=============================================
well_col = ["06"]
well_row = ["A"]

% ===================================================================================

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

% no interval 
Files_num = 1:1:1;  % a:b:c  a to c interval is b


% ============================TO CHANGE=============================================
% fi data
RFP_data = '_s1_w1.tif';
GFP_data = '_s1_w2.tif';

date_folder = 'E:\From NAS\ImageXpress\example_data\'
% ===================================================================================

addpath('./functions/');
mkdir([date_folder 'growth_rate_data\']);
mkdir([date_folder 'RFP_data\']);
mkdir([date_folder 'GFP_data\']);
% mkdir([date_folder 'growth_curve\']);
%% parfor loop for each well
for well = well_names

well = well_names;
%%% TO CHANGE
% Specify the name of the well (folder name).
Name_case_ori  = char(well); 
Name_case_ori;

%% Step 1. Image segmentation.



% ============================TO CHANGE=============================================
% 1. Load the directory for microscope images.
% Specify the directory to all the microscope images.
Path    = ['E:\From NAS\ImageXpress\example_data\input_data\TimePoint_*\'];

Image_Type = '_s1_w3.tif';    % For bright field  % use TL25 or YFP 
% ==================================================================================

% all figures directory
Name_case = [Name_case_ori Image_Type];
Name_case = ['*_' Name_case];
Files     = dir([Path Name_case]);

Temp = Files;
% order the figures by time point
for i = 1 : length(Files)
    s = regexp(Temp(i).folder,'TimePoint');
    Files(str2num(Temp(i).folder((s(1)+10):end))) = Temp(i);
end


Tif_Window.T = end_point;
start_time_point = start_point;

% Make a folder to store the cut images.
% Name_case = Name_case(3:8)
% if exist([date_folder Name_case]); rmdir([date_folder Name_case],'s'); end
% mkdir([date_folder Name_case]);

%% Recognize the yeast cells and cut the images.

%%% TO CHANGE
for i =  start_time_point:Tif_Window.T
   close all;
 i
% i=13;

% Identify Circle Edge and use 
% mask = uint16(Modify_Clone_Mask(imread([Files(i).folder '/' Files(i).name])));
% 
% mask
% Specify the region that you want to look at by using "Rectangle" tool in ImageJ to get the pixel coordinate.
% use a square of 6000*6000, x=1710, y=2255
% Tif_Window.xlim   = [mask(1)-3000 mask(1)+3000];      % [x x+w]
% Tif_Window.ylim   = [mask(2)-3000 mask(2)+3000];      % [y y+h]

Tif_Window.xlim   = [0 2160];      % [x x+w]
Tif_Window.ylim   = [0 2160];      % [y y+h]
 
% i=10
I = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});

%%% TO CHANGE
Params.fudgeFactor        = 0.85;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 300;
%%% END

BWfinal = Clone_RHX(I,Params);

% fuse_image = Merge_and_Adjust_only_for_BF_Seg(I,BWfinal);
% figure;
% imshow(fuse_image);

Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
Budding(i).mask             = BWfinal;  % find boundary for each cell

end

% save last segmentation figure
% savedir = 'E:\Project\2019__MitochondriaHeterogeneityHeritability\Software\YeastColonyTracking__Matlab_pipeline\';
% figure;
% imshow(BWfinal);
% title([Name_case_ori ' t = ' num2str(i) ' ( time point )']);
% saveas(gcf, fullfile(savedir,'\BW_final\',[Name_case_ori 'segmentation.png']))
% close all
% disp('Finished !!');

%% Store the data and record the GFP/RFP intensity.

%%% MUST RUN THIS LINE if you want to record GFP/RFP instensity

Budding = Modify_Budding_RFP_GFP_double(Budding,Name_case_ori,Path,Tif_Window,Files_num, RFP_data, GFP_data);
Budding = Budding(start_time_point:Tif_Window.T)
% Note that the function Budding_RFP_GFP might need to be changed 
% if there is no *_G_*.tiff or *_R_*.tiff files in the folder.

%save([Name_case '.mat']);
disp('Finished !!');
% figure;
% imshow(Budding(33).mask)

%% step 2. Trace every clone

Budding = Modify_Yeastbow_find_daughter(Budding);  % add daughter to the Budding
% show last segmentated figure wilth label

%RHX_0_Show_Last_Image_Cells(Budding);

%% step 3. Deal with merge situation, add merge to budding

for i = 1:length(Budding)
    if i == length(Budding);
        Budding(i).merge = repmat(0, length(Budding(i).daughter), 1)';
    else
        % how many cluster comes from same daughter
        temp = Budding(i).daughter;
        temp = struct("daughter", temp);
        for j = 1:length(Budding(i).daughter);
            temp.count(j) = histc(temp.daughter(:),temp.daughter(j));
        end
        
        % 0 labeled cluster do not remove
       for k = 1:length(temp.daughter)
            if temp.daughter(k) == 0;
                temp.count(k) = 1;
            end
       end
       Budding(i).merge = temp(:).count-1;
    end
end
%% step 4. show growth curves

% figure; 

[All_valid_area All_valid_area_RFP all_valid_area_GFP]= Modify_no_merge_Area_Curve_double(Budding,1:3000);
% 这个的上限其实是瞎设置的 反正也没有3000个
% RHX1_Area_Curve(Budding,1:1000);  % all 1000 cluster
% 
% RHX1_Area_Curve(Budding,112); % only the number 112 cluster
%xlim([10 80]);

% % save the figure
% title([Name_case_ori ' ' num2str(start_point) ' to ' num2str(end_point) ' ( time point )']);
% saveas(gcf, fullfile(date_folder,'growth_curve\',[Name_case_ori '_growth_curve.png']))
% close all

%% step 5. Play with specific patches, this can be repressed

% Lineages = Lineage(Budding,length(Budding),388);
% %%% END
% 
% figure;
% RHX2_Growth_Area(Lineages,Budding);
% 
% % If there is no *_G_*.tiff or *_R_*.tiff images in the folder, 
% % there might be an error.
% RHX4_RFP_GFP(Budding,Lineages);


%% step 6. video, this can be repressed

% Position.xlim   = [Tif_Window.xlim - min(Tif_Window.xlim)];
% Position.ylim   = [Tif_Window.ylim - min(Tif_Window.ylim)];
% 
% close all; figure; hold on; set(gcf,'color','w','position',[50 100 600*2 500]);  hold on;
% RHX3_show_lineage(Budding,Lineages,Position,Name_case)

%% step 7. calculate grwoth rate for valid cell cluster, use linear regression (ployfit)
% all left step will use R.

writetable(All_valid_area, [date_folder 'growth_rate_data\' Name_case_ori '_all_valid_area.csv']);

writetable(All_valid_area_RFP, [date_folder 'RFP_data\' Name_case_ori '_all_valid_area_RFP.csv']);

writetable(all_valid_area_GFP, [date_folder 'GFP_data\' Name_case_ori '_all_valid_area_GFP.csv']);

end

