clc; clear;

I = imread('data/Images_F11_3_O_Bf_Raw_b442a972-5b04-443e-8d14-d1d883a737e6.tiff');
% I = imread('data/Images_F11_4_O_Bf_Raw_2bb38c3e-139f-4246-ae0f-197492e4717d.tiff');
% I = imread('data/Images_F11_5_O_Bf_Raw_3442450c-bd60-4847-b617-d6d40d18f5bf.tiff');
% I = imread('data/Images_F11_6_O_Bf_Raw_0f63d8e4-a7a7-4090-a2f0-974b0ebd4d33.tiff');
% I = imread('data/Images_F11_7_O_Bf_Raw_0eb8ffbd-0bb9-459d-a74f-d8076a5fe144.tiff');



%%

%% Step 2: Detect Entire Cell

imshow(I)
title('Original Image');

[~,threshold] = edge(I,'sobel');
fudgeFactor   = 0.7; % 0.6  0.5 
BWs = edge(I,'sobel',threshold * fudgeFactor);

imshow(BWs)
title('Binary Gradient Mask')

%% Step 3: Dilate the Image

se90 = strel('line',3,90);
se0 = strel('line',3,0);

BWsdil = imdilate(BWs,[se90 se0]);
BWsdil = bwareaopen(BWsdil, 300);
imshow(BWsdil)

title('Dilated Gradient Mask')

%% Step 4: Fill Interior Gaps
% BWdfill = imfill(BWsdil,'holes');
BWdfill  = imfill_small_holes(BWsdil,400);
% previous = imread('y_7.tif')>0;
% BWdfill  = BWdfill | previous;
imshow(BWdfill)
title('Binary Image with Filled Holes')

%% Step 5: Remove Connected Objects on Border
BWnobord = (BWdfill);
 BWnobord = imclearborder(BWdfill,4);
imshow(BWnobord)
title('Cleared Border Image')


%% Step 6: Smooth the Object

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = bwareaopen(BWfinal, 400);

imshow(BWfinal)
title('Segmented Image');


imwrite(uint16(BWfinal),['Final.tif'], 'tif' );


%% Step 7: Visualize the Segmentation
