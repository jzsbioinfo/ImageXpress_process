clc; clear;



I = imread('data/Images_F11_9_O_Bf_Raw_81405a0a-f397-41b6-8898-23317fd8d824.tiff');
Previous = imread('8_y_BF.tif')>0;

% I = imread('data/Images_F11_8_O_Bf_Raw_7c0146a6-772d-4403-9747-e4fb63c09e1d.tiff');
% Previous = imread('7_y_BF.tif')>0;


imshow(I)
title('Original Image');

%% Step 2: Detect Entire Cell

[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.5;
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
BWdfill  = imfill_small_holes(BWsdil,1000);
% previous = imread('y_7.tif')>0;
BWdfill  = BWdfill | Previous;
BWdfill  = imfill_small_holes(BWdfill,1000);

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


%% Step 7: Visualize the Segmentation
% 
% imshow(labeloverlay(I,BWfinal))
% title('Mask Over Original Image')
% 
% 
% 
%  
% BWoutline = bwperim(BWfinal);
% Segout = I; 
% Segout(BWoutline) = 255; 
% imshow(Segout)
% title('Outlined Original Image')
% 
% 


