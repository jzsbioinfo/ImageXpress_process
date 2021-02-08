
function merge_adjust_less  =  Merge_and_Adjust_only_for_BF_double(BF, FI1,FI2)

% BF = I;
% Seg = BWfinal;
% BF=I;
% FI1=I_FI;
% FI2=I_FI2;

Merge=zeros([size(BF) 3]);
%% adjust BF
% Calculate the standard deviation and the image mean for stretching.

Idouble = im2double(BF); 
avg = mean2(Idouble);
sigma = std2(Idouble);

n = min(avg/sigma-0.0001, (1-avg)/sigma-0.0001);

% Adjust the contrast based on the standard deviation.
BF = imadjust(BF,[avg-n*sigma avg+n*sigma],[]);


%% adjust seg
% Seg = uint16(Seg)*10000; % adjust segmentation color: green

%% adjust FI
FI1 = imadjust(FI1)*0.2;  % imadjust 对所有像素值中最低的 1% 和最高的 1% 进行饱和处理。此运算可提高输出图像 J 的对比度。
FI2 = imadjust(FI2)*0.2;
%% merge_adjust_less

Merge(:,:,1) = BF + 1*FI1;   % change color depth of the FI
Merge(:,:,2) = BF + 1*FI2; 
Merge(:,:,3) = BF ; 

merge_adjust_less = uint16(Merge);

% figure('Name','0.4')
% imshow(merge_adjust_less)
