
function merge_adjust_less  =  Merge_and_Adjust_only_for_BF_Seg(BF, Seg)

% BF = I;
% Seg = BWfinal;


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
Seg = uint16(Seg)*10000; % adjust segmentation color: green

%% adjust FI
% FI = imadjust(FI)*0.2;

%% merge_adjust_less

Merge(:,:,1) = BF ;   % change color depth of the FI
Merge(:,:,2) = BF + 1*Seg; 
Merge(:,:,3) = BF ; 

merge_adjust_less = uint16(Merge);

% figure
% imshow(merge_adjust_less)
