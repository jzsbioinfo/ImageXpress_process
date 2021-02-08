%% 2019 09 02 forward calculation to deal with merge event

clc; clear;
%% all wells need to process

well_col = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"]

%well_col = ["07" "08" "09" "10" "11" "12"]
% 
well_row = ["A" "B" "C" "D" "E" "F" "G" "H"]

%well_row = ["C"]

well_col = ["03" "04" "06"]
well_row = ["B" "C" "D" "E"]


well_names=[]

for i = well_row
    for j = well_col
        well_names = [well_names, (i + num2str(j)) ];
        %well_names = convertStringsToChars([well_names, (i + num2str(j)) ]);
    end
end   

% Specify the total number of timepoints in the folder or the number of timepoints you want to check.
start_point =1;
end_point = 10;

date_folder = 'Z:\MD\Analysis_data_Zhisheng\12th_TL25_mCherry_40X\analysis\'

mkdir([date_folder 'growth_rate_data\']);

mkdir([date_folder 'RFP_data\']);

mkdir([date_folder 'growth_curve\']);
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
Path    = ['Z:\MD\12th_TL25_mCherry_40X\20191031 40X_246\TimePoint_*\'];

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
 i
 
 


% Identify Circle Edge and use 
mask = uint16(Modify_Clone_Mask(imread([Files(i).folder '/' Files(i).name])));

mask

 % Specify the region that you want to look at by using "Rectangle" tool in ImageJ to get the pixel coordinate.

% use a square of 6000*6000, x=1710, y=2255
Tif_Window.xlim   = [mask(1)-3000 mask(1)+3000];      % [x x+w]
Tif_Window.ylim   = [mask(2)-3000 mask(2)+3000];      % [y y+h]

% Tif_Window.xlim   = [0 11664];      % [x x+w]
% Tif_Window.ylim   = [0 11664];      % [y y+h]
 
 
I     = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});
%I     = imread([Files(i).folder '/' Files(i).name]);
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


% I  = imread('Z:\MD\15th_20191117_for_prediction_10X\20191116drug-prediction4_D02_w1-1.tif');

% imshow(uint8(I));
% 
% J= uint8(I);

% I_old = I;
%%% TO CHANGE
Params.fudgeFactor        = 0.85;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 1;     % remove border cells or not
Params.remove_small_patch = 20;
%%% END

BWfinal = Clone_RHX(I,Params);

figure
imshowpair(I,BWfinal)
%BF


max(max(BWfinal));


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

% ==============

% imwrite(uint16(BWfinal),'mask3.tif', 'tif' );

% number to get right order
%  if i>9
%      order_num = num2str(i);
% else
%      order_num = ['0' num2str(i)];
% end




% imwrite(uint16(I),[date_folder Name_case '\BF' num2str(i.','%02d') Files(i).folder((end-10):end) '.tif'], 'tif' );
% imwrite(uint16(BWfinal),[date_folder Name_case '\Seg' num2str(i.','%02d') Files(i).folder((end-10):end) '.tif'], 'tif' );


    Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
    Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
    Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
    Budding(i).mask             = BWfinal;  % find boundary for each cell

end

toc;

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

Budding = Modify_Budding_RFP_GFP(Budding,Name_case_ori,Path,Tif_Window,Files_num);

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

figure; 

[All_valid_area All_valid_area_RFP]= Modify_no_merge_Area_Curve(Budding,1:1000);
% 这个的上限其实是瞎设置的 反正也没有1000个
% RHX1_Area_Curve(Budding,1:1000);  % all 1000 cluster
% 
% RHX1_Area_Curve(Budding,112); % only the number 112 cluster
%xlim([10 80]);

% % save the figure
title([Name_case_ori ' ' num2str(start_point) ' to ' num2str(end_point) ' ( time point )']);
saveas(gcf, fullfile(date_folder,'growth_curve\',[Name_case_ori '_growth_curve.png']))
close all




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
%% all left step will use R.



writetable(All_valid_area, [date_folder 'growth_rate_data\' Name_case_ori '_all_valid_area.csv'])

writetable(All_valid_area_RFP, [date_folder 'RFP_data\' Name_case_ori '_all_valid_area_RFP.csv'])

end


% % filter cell cluster give valid datab
% All_valid_area_matrix = All_valid_area.Variables;
% zeros = []
% for i = 1:size(All_valid_area,2)
%     zeros_t = histc(All_valid_area(:,i),0)
%     zeros = [zeros, zeros_t]
% end
% 
% histc(double(All_valid_area_matrix(:,79) > 0),1)
%     
% All_valid_area_filter = All_valid_area(:,)
% 
% time_point = start_time_point:Tif_Window.T
% growth_rate = []
% 
% for i = 1:
% 
% All_valid_area(:,1)



%% save 

save([Name_case '.mat']);  % save all exist variable now
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




%% ---------------------------------------------------------------------------------------------------------------------------
%% modified in 2019 08 13
%% to calculate mCherry intensity in the convex hull area


Image_Type_mCherry = '*_O_R_*.tif*';


Files_mCherry    = dir([Path Image_Type_mCherry]);

Temp = Files_mCherry;

% order the file names
for i = 1 : length(Files_mCherry)
    s = regexp(Temp(i).name,'_');
    Files_mCherry(str2num(Temp(i).name((s(2)+1):(s(3)-1)))) = Temp(i);
end


Files_mCherry_name = Files_mCherry(Tif_Window.T).name



mCherry = imread([Files(1).folder '/' Files_mCherry_name],'PixelRegion',{Tif_Window.ylim ,Tif_Window.xlim});

% convexhull = Budding(16).ROIs(141).ConvexHull;

BWfinal_int = uint8(BWfinal);

grey_level_matrix = BWfinal_int .* mCherry;

grey_level_area = regionprops(grey_level_matrix,'area');

BWfinal_int_area = regionprops(BWfinal_int,'area');



%% -------------
stat=regionprops(BWfinal,mCherry,'Area','MeanIntensity', 'PixelValues');

%% to sum the pixel value for each area
temp = [];

[r c] = size([stat.Area]')

for i = 1:r
    temp(i) = sum([stat(i).PixelValues]);
end

temp = num2cell(temp);

[stat(:).SumIntensity] = deal(temp{:});

% add growth rate to each cluster

[stat(:).Growthrate] = deal(temp{:});


%% plot the result

figure;
color = colormap([0.5 0 0]);

    
plot([stat.Area],[stat.SumIntensity], '.', 'MarkerSize',14, 'color', color )
%title(["20190730 Well" + "-" + Name_case_ori])
xlabel("area size")
ylabel("area sum mCherry intensity")
grid on;
box on;
%axis equal;

title([Name_case_ori ' t to ' num2str(Tif_Window.T ) ' ( time point )']);
saveas(gcf, fullfile(savedir,'\growth_curve\',[Name_case_ori 'growth_curve_analysis1.png']))
close all



figure;

plot([stat.Area],[stat.MeanIntensity], '.', 'MarkerSize',14, 'color', color )
title(["20190730 Well" + "-" + Name_case_ori])
xlabel("area size")
ylabel("area mean mCherry intensity")
grid on;
box on;

title([Name_case_ori ' t to ' num2str(Tif_Window.T ) ' ( time point )']);
saveas(gcf, fullfile(savedir,'\growth_curve\',[Name_case_ori 'growth_curve_analysis2.png']))
close all

%end

















