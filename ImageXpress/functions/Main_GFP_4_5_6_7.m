clc; clear;


 I = imread('data/Images_F11_3_O_G_Raw_469fe9f9-780f-433f-a8df-31e3fc72379d.tiff');
% I = imread('data/Images_F11_4_O_G_Raw_39f0b973-f2d2-486c-b54c-6b0d57b1431d.tiff');
% I = imread('data/Images_F11_5_O_G_Raw_d3bfa05f-c7cc-46c4-89ff-9878fde18452.tiff');
% I = imread('data/Images_F11_6_O_G_Raw_b9c3bfc5-9d1b-45be-b3b0-b74d28a6fa38.tiff');
% I = imread('data/Images_F11_7_O_G_Raw_457e5c3d-869f-42de-8301-526c4e26adbb.tiff');


imshow(I)
title('Original Image');

%% Step 2: Detect Entire Cell

[~,threshold] = edge(I,'sobel');
fudgeFactor   = .4;
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
BWdfill = imfill(BWsdil,'holes');
% BWdfill  = imfill_small_holes(BWsdil,400);
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
BWfinal = bwareaopen(BWfinal, 300);

imshow(BWfinal)
title('Segmented Image');


imwrite(uint16(BWfinal),['Final.tif'], 'tif' );

