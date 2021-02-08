
%%  BF images

clc; clear;


% I = imread('data/Images_F11_3_O_Bf_Raw_b442a972-5b04-443e-8d14-d1d883a737e6.tiff');
I = imread('data/Images_F11_4_O_Bf_Raw_2bb38c3e-139f-4246-ae0f-197492e4717d.tiff');
% I = imread('data/Images_F11_5_O_Bf_Raw_3442450c-bd60-4847-b617-d6d40d18f5bf.tiff');
% I = imread('data/Images_F11_6_O_Bf_Raw_0f63d8e4-a7a7-4090-a2f0-974b0ebd4d33.tiff');
% I = imread('data/Images_F11_7_O_Bf_Raw_0eb8ffbd-0bb9-459d-a74f-d8076a5fe144.tiff');


% Params.fudgeFactor        = 0.7;   % larger value will remove background noise
% Params.small_holes        = 400;     % 
% Params.clear_border       = 0;     % remove border cells or not
% Params.remove_small_patch = 400;

BWfinal = Clone_RHX(I,Params);

figure;
imshowpair(I,BWfinal)
title('Segmented Image');


imwrite(uint16(BWfinal),['Final.tif'], 'tif' );

%%
clc; clear;

I = imread('data/Images_F11_3_O_Bf_Raw_b442a972-5b04-443e-8d14-d1d883a737e6.tiff');
% I = imread('data/Images_F11_4_O_Bf_Raw_2bb38c3e-139f-4246-ae0f-197492e4717d.tiff');
% I = imread('data/Images_F11_5_O_Bf_Raw_3442450c-bd60-4847-b617-d6d40d18f5bf.tiff');
% I = imread('data/Images_F11_6_O_Bf_Raw_0f63d8e4-a7a7-4090-a2f0-974b0ebd4d33.tiff');
% I = imread('data/Images_F11_7_O_Bf_Raw_0eb8ffbd-0bb9-459d-a74f-d8076a5fe144.tiff');

Params.fudgeFactor        = 0.4;   % larger value will remove background noise
Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
Params.clear_border       = 0;     % remove border cells or not
Params.remove_small_patch = 300;


BWfinal = Clone_RHX(I,Params);

figure;
imshowpair(I,BWfinal)
title('Segmented Image');
imwrite(uint16(BWfinal),['Final.tif'], 'tif' );

%%