

clc; clear;

Files = dir('*.tiff');

for i = 1:length(Files)
    
    if strfind(  Files(i).name, '_O_Bf_Raw_')
        movefile(Files(i).name,['BF/' Files(i).name]);
    end
    if strfind(  Files(i).name, '_O_G_Raw_')
        movefile(Files(i).name,['GFP/' Files(i).name]);
    end    
end   
    
%%


J = imcrop(I,[0 1656 3256 5400]);


% clc; clear;
% 
% Files = dir('*.tiff');
% 
% for i = 1:length(Files)
%     if strfind(  Files(i).name, '_O_Bf_Raw_')
%         copyfile(Files(i).name,['BF/' Files(i).name]);
%     end
%     if strfind(  Files(i).name, '_O_G_Raw_')
%         copyfile(Files(i).name,['GFP/' Files(i).name]);
%     end    
% end   
%     
    
% I = imread('data/Images_F11_3_O_Bf_Raw_b442a972-5b04-443e-8d14-d1d883a737e6.tiff');
I = imread('data/Images_F11_4_O_Bf_Raw_2bb38c3e-139f-4246-ae0f-197492e4717d.tiff');
% I = imread('data/Images_F11_5_O_Bf_Raw_3442450c-bd60-4847-b617-d6d40d18f5bf.tiff');
% I = imread('data/Images_F11_6_O_Bf_Raw_0f63d8e4-a7a7-4090-a2f0-974b0ebd4d33.tiff');
% I = imread('data/Images_F11_7_O_Bf_Raw_0eb8ffbd-0bb9-459d-a74f-d8076a5fe144.tiff');


imwrite(uint16(BWfinal),['Final.tif'], 'tif' );


