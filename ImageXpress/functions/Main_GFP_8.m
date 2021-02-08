clc; clear;

% I = imread('data/Images_F11_8_O_G_Raw_bb684f95-231d-42a5-8bc8-fc9951e1c20d.tiff');
% Previous = imread('7_y_GFP.tif')>0;

% I = imread('data/Images_F11_8_O_G_Raw_bb684f95-231d-42a5-8bc8-fc9951e1c20d.tiff');
% Previous = imread('7_y_GFP.tif')>0;

imshow(I)
title('Original Image');

%% Step 2: Detect Entire Cell

[~,threshold] = edge(I,'sobel');
fudgeFactor   = .5;
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
% BWdfill  = imfill_small_holes(BWsdil,2000);
% previous = imread('y_7.tif')>0;
BWdfill  = BWdfill | Previous;
imshow(BWdfill)
title('Binary Image with Filled Holes')

%% Step 5: Remove Connected Objects on Border
BWnobord = (BWdfill);
% BWnobord = imclearborder(BWdfill,4);
imshow(BWnobord)
title('Cleared Border Image')


%% Step 6: Smooth the Object

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = bwareaopen(BWfinal, 800);

imshow(BWfinal)
title('Segmented Image');


imwrite(uint16(BWfinal),['Final.tif'], 'tif' );

